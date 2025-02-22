package org.ssssssss.magicboot.interceptor;

import cn.dev33.satoken.secure.SaSecureUtil;
import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.ObjectUtil;
import com.alibaba.druid.pool.DruidDataSource;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.core.context.MagicUser;
import org.ssssssss.magicapi.core.exception.MagicLoginException;
import org.ssssssss.magicapi.core.interceptor.AuthorizationInterceptor;
import org.ssssssss.magicboot.data.entity.SysTenant;
import org.ssssssss.magicboot.data.service.SysTenantService;
import org.ssssssss.magicboot.enums.TenantDbType;
import org.ssssssss.magicboot.enums.TenantStatus;
import org.ssssssss.magicboot.utils.DruidTenantDataSourceUtil;

import java.util.Map;

/**
 * Magic-Api登录拦截器
 *
 * @author Yean (clarence@lightwing.net)
 * @date 2025-2-16 19:29:27
 */
@Component
public class MagicApiAuthorizationInterceptor implements AuthorizationInterceptor {

    @Resource
    private HttpServletRequest httpServletRequest;

    @Resource
    private JdbcTemplate jdbcTemplate;

    @Resource
    private SysTenantService sysTenantService;

    @Resource
    private DruidTenantDataSourceUtil druidTenantDataSourceUtil;

    @Override
    public boolean requireLogin() {
        return true;
    }

    @Override
    public MagicUser login(String username, String password) throws MagicLoginException {
        // 根据当前域名查询租户
        SysTenant tenantInfo = sysTenantService.getTenantByDomain(httpServletRequest.getServerName());

        if (ObjectUtil.isEmpty(tenantInfo)) {
            throw new MagicLoginException("很抱歉,租户不存在,请检查当前域名是否正确");
        } else {
            if (TenantStatus.EXPIRED.getCode().equals(tenantInfo.getStatus())) {
                throw new MagicLoginException("很抱歉,租户已禁用");
            }
            return handleTenantLogin(tenantInfo, username, password);
        }
    }

    @Override
    public MagicUser getUserByToken(String token) throws MagicLoginException {
        String loginId = (String) StpUtil.getLoginIdByToken(token);
        if (StpUtil.isLogin(loginId)) {
            return new MagicUser(loginId, loginId, token);
        } else {
            throw new MagicLoginException("很抱歉,Token无效");
        }
    }

    @Override
    public void logout(String token) {
        String loginId = (String) StpUtil.getLoginIdByToken(token);
        StpUtil.logout(loginId);
    }

    /**
     * 处理租户登录
     *
     * @param tenantInfo
     * @return
     */
    public MagicUser handleTenantLogin(SysTenant tenantInfo, String username, String password) throws MagicLoginException {
        TenantDbType dbType = TenantDbType.valueOf(tenantInfo.getDbType());
        
        DruidDataSource tenantDataSource = null;
        try {
            // 使用工具类创建数据源
            tenantDataSource = druidTenantDataSourceUtil.createTenantDataSource(
                dbType.getDriverClassName(),
                tenantInfo.getDbJdbcUrl(),
                tenantInfo.getDbUser(),
                tenantInfo.getDbPassword()
            );
            
            // 使用临时JdbcTemplate查询用户
            JdbcTemplate tenantJdbcTemplate = new JdbcTemplate(tenantDataSource);
            Map<String, Object> userInfo = tenantJdbcTemplate.queryForMap(
                "select * from sys_user where username = ? and password = ? and is_del = 0 limit 1",
                username, 
                SaSecureUtil.sha256(password)
            );

            if (MapUtil.isNotEmpty(userInfo)) {
                StpUtil.login(tenantInfo.getId() + ":" + userInfo.get("id"));
                MagicUser user = new MagicUser();
                user.setToken(StpUtil.getTokenValue());
                user.setUsername(tenantInfo.getId() + ":" + username);
                user.setId(tenantInfo.getId() + "_" + userInfo.get("id").toString());
                return user;
            } else {
                throw new MagicLoginException("很抱歉,用户名或密码错误");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new MagicLoginException("登录失败: " + e.getMessage());
        } finally {
            // 使用工具类关闭数据源
            druidTenantDataSourceUtil.closeDataSource(tenantDataSource);
        }
    }
}

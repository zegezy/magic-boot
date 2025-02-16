package org.ssssssss.magicboot.interceptor;

import cn.dev33.satoken.secure.SaSecureUtil;
import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.map.MapUtil;
import com.alibaba.druid.pool.DruidDataSource;
import com.mysql.cj.jdbc.JdbcConnection;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.core.context.MagicUser;
import org.ssssssss.magicapi.core.exception.MagicLoginException;
import org.ssssssss.magicapi.core.interceptor.AuthorizationInterceptor;
import org.ssssssss.magicboot.enums.TenantDbType;

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

    @Override
    public boolean requireLogin() {
        return true;
    }

    @Override
    public MagicUser login(String username, String password) throws MagicLoginException {
        // 根据当前域名查询租户
        Map<String, Object> tenantInfo = jdbcTemplate.queryForMap("""
                    select st.*
                    from sys_tenant_platform stp
                             left join sys_tenant st on (st.id = stp.tenant_id)
                    where stp.identifier = ? limit 1
                """, httpServletRequest.getServerName());

        if (MapUtil.isEmpty(tenantInfo)) {
            throw new MagicLoginException("很抱歉,租户不存在,请检查当前域名是否正确");
        } else {
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
    public MagicUser handleTenantLogin(Map<String, Object> tenantInfo, String username, String password) {
        TenantDbType dbType = TenantDbType.valueOf(tenantInfo.get("db_type").toString());
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setUrl((String) tenantInfo.get("db_jdbc_url"));
        dataSource.setUsername((String) tenantInfo.get("db_user"));
        dataSource.setPassword((String) tenantInfo.get("db_password"));
        dataSource.setDriverClassName(dbType.getDriverClassName());

        JdbcTemplate template = new JdbcTemplate(dataSource);
        try {
            Map<String, Object> userInfo = template.queryForMap("""
                        select * from sys_user where username = ? and password = ? limit 1;
                    """, username, SaSecureUtil.sha256(password));
            if (MapUtil.isNotEmpty(userInfo)) {
                StpUtil.login(tenantInfo.get("id") + ":" + userInfo.get("id"));
                MagicUser user = new MagicUser();
                user.setToken(StpUtil.getTokenValue());
                user.setUsername(tenantInfo.get("id") + ":" + username);
                user.setId(tenantInfo.get("id") + "_" + userInfo.get("id").toString());

                return user;
            } else {
                throw new MagicLoginException("很抱歉,用户名或密码错误");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

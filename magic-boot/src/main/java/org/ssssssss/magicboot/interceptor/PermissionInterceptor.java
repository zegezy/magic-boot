package org.ssssssss.magicboot.interceptor;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.extra.servlet.ServletUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.ssssssss.magicapi.core.context.RequestEntity;
import org.ssssssss.magicapi.core.interceptor.RequestInterceptor;
import org.ssssssss.magicapi.core.model.ApiInfo;
import org.ssssssss.magicapi.core.model.Options;
import org.ssssssss.magicapi.core.service.MagicAPIService;
import org.ssssssss.magicapi.core.service.MagicResourceService;
import org.ssssssss.magicapi.core.servlet.MagicHttpServletRequest;
import org.ssssssss.magicapi.core.servlet.MagicHttpServletResponse;
import org.ssssssss.magicapi.utils.PathUtils;
import org.ssssssss.magicboot.model.StatusCode;
import org.ssssssss.script.MagicScriptContext;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

@Component
@Order(1)
public class PermissionInterceptor implements RequestInterceptor, HandlerInterceptor {

    @Autowired
    MagicAPIService magicAPIService;

    @Autowired
    MagicResourceService magicResourceService;

    @Autowired
    private JdbcTemplate template;

    /*
     * 当返回对象时，直接将此对象返回到页面，返回null时，继续执行后续操作
     */
    @Override
    public Object preHandle(ApiInfo info, MagicScriptContext context, MagicHttpServletRequest request, MagicHttpServletResponse response) {
        String requireLogin = Objects.toString(info.getOptionValue(Options.REQUIRE_LOGIN), "");
        if(requireLogin.equals("false")){
            return null;
        }
        if(!StpUtil.isLogin()){
            return StatusCode.CERTIFICATE_EXPIRED.json();
        } else {
            // TODO
            List<String> permissions = (List<String>) magicAPIService.execute("post", "/system/security/permissions", new HashMap<String, Object>());
            String permission = Objects.toString(info.getOptionValue(Options.PERMISSION), "");
            if (StringUtils.isNotBlank(permission) && !permissions.contains(permission)) {
                return StatusCode.FORBIDDEN.json();
            }
        }
        return null;
    }

    @Override
    public Object postHandle(RequestEntity requestEntity, Object returnValue) throws Exception {
        if(StpUtil.isLogin()){
            try {
                HttpServletRequest request = requestEntity.getRequest().getRequest();
                ApiInfo info = requestEntity.getApiInfo();
                template.update("insert into sys_oper_log(api_name, api_path, api_method, cost_time, create_by, create_date, user_agent, user_ip) values(?,?,?,?,?,?,?,?)",
//                    PathUtils.replaceSlash(groupServiceProvider.getFullName(info.getGroupId()) + "/" + info.getName()).replace("/","-"),
                        PathUtils.replaceSlash(String.format("/%s/%s", magicResourceService.getGroupName(info.getGroupId()), info.getName())),
                        request.getRequestURI(),
                        request.getMethod(),
                        System.currentTimeMillis() - requestEntity.getRequestTime(),
                        StpUtil.getLoginId(),
                        new Date(requestEntity.getRequestTime()),
                        request.getHeader("User-Agent"),
                        ServletUtil.getClientIP(request));
            } catch (Exception ignored){
                ignored.printStackTrace();
            }
        }
        return null;
    }

}

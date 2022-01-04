package org.ssssssss.magicboot.interceptor;

import cn.dev33.satoken.stp.StpUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.interceptor.RequestInterceptor;
import org.ssssssss.magicapi.model.ApiInfo;
import org.ssssssss.magicapi.model.Options;
import org.ssssssss.magicapi.provider.MagicAPIService;
import org.ssssssss.magicboot.model.StatusCode;
import org.ssssssss.script.MagicScriptContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Objects;

@Component
@Order(1)
public class PermissionInterceptor implements RequestInterceptor {

    @Autowired
    MagicAPIService magicAPIService;

    /*
     * 当返回对象时，直接将此对象返回到页面，返回null时，继续执行后续操作
     */
    @Override
    public Object preHandle(ApiInfo info, MagicScriptContext context, HttpServletRequest request, HttpServletResponse response) {
        String requireLogin = Objects.toString(info.getOptionValue(Options.REQUIRE_LOGIN), "");
        if(requireLogin.equals("false")){
            return null;
        }
        if(!StpUtil.isLogin()){
            return StatusCode.CERTIFICATE_EXPIRED.json();
        } else {
            // TODO
            List<String> permissions = (List<String>) magicAPIService.execute("post", "/security/permissions", null);
            String permission = Objects.toString(info.getOptionValue(Options.PERMISSION), "");
            if (StringUtils.isNotBlank(permission) && !permissions.contains(permission)) {
                return StatusCode.FORBIDDEN.json();
            }
        }
        return null;
    }

}

package org.ssssssss.magicboot.utils;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.ssssssss.magicboot.model.Global;

import javax.servlet.http.HttpServletRequest;

public class WebUtils {

    public static HttpServletRequest getHttpServletRequest(){
		return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	}

    public static String getContextUrl() {
        HttpServletRequest request = getHttpServletRequest();
        StringBuffer url = request.getRequestURL();
        return url.delete(url.length() - request.getRequestURI().length(), url.length()).append(request.getServletContext().getContextPath()).append("/").toString();
    }

    public static String getUeditorPrefix(){
        return getContextUrl();
    }

}

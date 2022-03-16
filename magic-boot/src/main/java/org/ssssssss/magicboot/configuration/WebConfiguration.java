package org.ssssssss.magicboot.configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.scheduling.concurrent.ConcurrentTaskExecutor;
import org.springframework.web.servlet.config.annotation.AsyncSupportConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.ssssssss.magicboot.model.Global;

import java.util.concurrent.Executors;

@Configuration
public class WebConfiguration implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(Global.USER_FILES_BASE_URL + "**").addResourceLocations("file:" + Global.getDir() + Global.USER_FILES_BASE_URL);
    }

}

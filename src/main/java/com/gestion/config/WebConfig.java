package com.gestion.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.support.ConfigurableWebBindingInitializer;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Configuration pour servir les fichiers CSS
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
        
        // Configuration pour servir les fichiers JS
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
        
        // Configuration pour servir les images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
    }

} 
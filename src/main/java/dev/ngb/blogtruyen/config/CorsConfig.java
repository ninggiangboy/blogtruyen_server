package dev.ngb.blogtruyen.config;

import dev.ngb.blogtruyen.config.property.CorsProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties(CorsProperties.class)
public class CorsConfig {
}

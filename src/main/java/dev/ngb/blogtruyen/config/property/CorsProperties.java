package dev.ngb.blogtruyen.config.property;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.Map;

@ConfigurationProperties(prefix = "cors")
public record CorsProperties(
        Map<String, String> headers
) {
}

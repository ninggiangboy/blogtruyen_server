package dev.ngb.blogtruyen.config.property;

import lombok.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.Map;

@ConfigurationProperties(prefix = "cors")
@Value
public class CorsProperties {
    Map<String, String> headers;
}

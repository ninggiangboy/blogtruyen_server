package dev.ngb.blogtruyen.config;

import dev.ngb.blogtruyen.config.property.ElasticsearchProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchConfiguration;

@Configuration
@EnableConfigurationProperties(ElasticsearchProperties.class)
public class ElasticsearchConfig extends ElasticsearchConfiguration {

    private final String host;
    private final int port;

    public ElasticsearchConfig(ElasticsearchProperties properties) {
        this.host = properties.host();
        this.port = properties.port();
    }

    @Override
    public ClientConfiguration clientConfiguration() {
        String address = host + ":" + port;
        return ClientConfiguration.builder()
                .connectedTo(address)
                .build();
    }
}

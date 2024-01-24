package dev.ngb.blogtruyen.exception.handler;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record ErrorResponse(
        int status,
        String path,
        @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss")
        LocalDateTime timestamp,
        String message
) {
}



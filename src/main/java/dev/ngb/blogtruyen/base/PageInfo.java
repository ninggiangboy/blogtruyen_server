package dev.ngb.blogtruyen.base;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.DecimalMin;
import lombok.Data;

@Data
public class PageInfo {
    @DecimalMin(value = "1")
    private Integer page = 1;
    @JsonProperty("per_page")
    private Integer size = 10;
}

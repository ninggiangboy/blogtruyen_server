package dev.ngb.blogtruyen.validation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = NullOrNotBlankValidator.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface NullOrNotBlank {
    String message() default "Field can not be blank";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}

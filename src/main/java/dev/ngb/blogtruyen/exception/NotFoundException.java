package dev.ngb.blogtruyen.exception;

public class NotFoundException extends ClientErrorException {
    public NotFoundException(String message) {
        super(message);
    }
}

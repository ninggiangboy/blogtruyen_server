package dev.ngb.blogtruyen.exception;

public class ConflictException extends ClientErrorException {
    public ConflictException(String message) {
        super(message);
    }
}

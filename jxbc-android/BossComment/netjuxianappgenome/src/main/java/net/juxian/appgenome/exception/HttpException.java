package net.juxian.appgenome.exception;


public class HttpException extends Exception {
	private static final long serialVersionUID = 1L;
	
	private int statusCode;

    public HttpException() {
    }

    public HttpException(String message) {
        super(message);
    }

    public HttpException(String message, Throwable throwable) {
        super(message, throwable);
    }

    public HttpException(Throwable throwable) {
        super(throwable);
    }

    public HttpException(int statusCode) {
        this.statusCode = statusCode;
    }

    public HttpException(int statusCode, String message) {
        super(message);
        this.statusCode = statusCode;
    }

    public HttpException(int statusCode, String message, Throwable throwable) {
        super(message, throwable);
        this.statusCode = statusCode;
    }

    public HttpException(int statusCode, Throwable throwable) {
        super(throwable);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return statusCode;
    }
}

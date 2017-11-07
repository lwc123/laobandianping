package net.juxian.appgenome.exception;

public class NotImplementedException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	public NotImplementedException() {
		
	}
	
	@Override
    public String getMessage() {
        return "Not implemented.";
    }

}

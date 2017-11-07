package net.juxian.appgenome.receiver;


public class PushHandlerBase  implements IPushHandler {
	
	@Override
	public boolean processOpenedNotification(PushMessage msg) {		
		return false;
	}
}

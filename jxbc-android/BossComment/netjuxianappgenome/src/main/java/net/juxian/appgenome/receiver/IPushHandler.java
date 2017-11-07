package net.juxian.appgenome.receiver;


public interface IPushHandler {

	boolean processOpenedNotification(PushMessage msg);
}

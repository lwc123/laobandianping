package net.juxian.appgenome;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class TaskThreadPool {
	
	private static class SingletonHolder { 
	    private static final TaskThreadPool Instance = new TaskThreadPool(); 
	}
	
	public static TaskThreadPool getInstance(){
        return SingletonHolder.Instance;
    }
	
	private ExecutorService service;
	
	private TaskThreadPool(){
		int count = Runtime.getRuntime().availableProcessors();
		service = Executors.newFixedThreadPool(count);
	}
		
	public void addTask(Runnable runnable){
		service.submit(runnable);
	}
	
}
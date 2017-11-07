package net.juxian.appgenome;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

import android.text.TextUtils;

public class ObjectIOCFactory {

	private static HashMap<String, Class<?>> TypeAliasMap = new HashMap<String, Class<?>>();
	private static HashMap<String, Object> SingletonMap = new HashMap<String, Object>();

	public static <T> T getSingleton(Class<T> type) {
		return getSingleton(type, null);
	}
	
	@SuppressWarnings("unchecked")
	public static <T> T getSingleton(Class<T> type, String alias) {
		String aliasKey = getTypeAlias(type, alias);
		if (false == SingletonMap.containsKey(aliasKey)) {
			synchronized (ObjectIOCFactory.class) {
				Object instance = SingletonMap.get(aliasKey);
				if (instance == null) {
					synchronized (ObjectIOCFactory.class) {
						instance = resolveInstance(type);
					}
					SingletonMap.put(aliasKey, instance);
				}
			}
		}
		return (T)SingletonMap.get(aliasKey);
	}

	public static <T> T resolveInstance(Class<T> type) {
		return resolveInstance(type, null);
	}
	
	@SuppressWarnings("unchecked")
	public static <T> T resolveInstance(Class<T> type, String alias) {		
		String aliasKey = getTypeAlias(type, alias);
		Class<?> clazz = null;
		if(TypeAliasMap.containsKey(aliasKey)) {
			clazz = TypeAliasMap.get(aliasKey);
		} else if (null == alias){
			if(type.isInterface() || type.getModifiers() == Modifier.ABSTRACT) {
				throw new IllegalArgumentException(String.format("%s not cannot be created.", type.getName()));
			} else {
				clazz = type;
			}
		}
		
		Object instance = null;		
		if(null == clazz) {	
			throw new IllegalArgumentException(String.format("%s not defined.", aliasKey));
		} else {		
			try {
				instance = build(clazz);
			} catch (InvocationTargetException ex) {
				throw new IllegalArgumentException(String.format("%s create error. %s", clazz.getName(), ex.getTargetException().toString()), ex.getTargetException());
			}
			catch (Exception ex) {
				throw new IllegalArgumentException(String.format("%s create error. %s", clazz.getName(), ex.toString()), ex);
			}
		}
		return (T)instance;
	}

	public static void registerTypeAlias(Class<?> type, Class<?> impl) {
		registerTypeAlias(type, impl, null);
	}

	public static void registerTypeAlias(Class<?> type, Class<?> impl, String alias) {
		if(false == type.isAssignableFrom(impl)) {
			throw new ClassCastException(String.format("%s not cast to %s.", impl.getName(), type.getName()));
		}
		
		String aliasKey = getTypeAlias(type, alias);
		if(false == TypeAliasMap.containsKey(aliasKey)) {
			synchronized (ObjectIOCFactory.class) {
				if(false == TypeAliasMap.containsKey(aliasKey)) {
					TypeAliasMap.put(aliasKey, impl);
				}
			}
		}
	}
	
	private static String getTypeAlias(Class<?> type, String alias) {
		String aliasKey = null;
		if(TextUtils.isEmpty(alias)) {
			aliasKey = type.getName();
		} else {
			aliasKey = String.format("{0}:{1}", type.getName(), alias);
		}
		return aliasKey;
	}
	
	private static Object build(Class<?> clazz) throws InstantiationException, IllegalAccessException, NoSuchMethodException, IllegalArgumentException, InvocationTargetException {
		Constructor<?> constructor = clazz.getDeclaredConstructor();
		constructor.setAccessible(true);
		Object instance = constructor.newInstance();
		
		Field[] fields = clazz.getDeclaredFields();
		for(Field field : fields) {
			Class<?> fieldType = field.getType();
			if(IResolveObject.class.isAssignableFrom(fieldType)){
				Object fieldValue = build(fieldType);				
				field.setAccessible(true);
				field.set(instance, fieldValue);
			}
		}
		
		if(IResolveObject.class.isAssignableFrom(clazz)){
			((IResolveObject)instance).initialize();
		}
		return instance;
	}
}

package com.lcw.crm.utils;

import java.lang.reflect.Proxy;
import java.util.ArrayList;

public class ServiceFactory {
	
	public static Object getService(Object service){
		
		return new TransactionInvocationHandler(service).getProxy();

	}

	/*public static Object getService(Object service){

		return Proxy.newProxyInstance(service.getClass().getClassLoader(),service.getClass().getInterfaces(),new TransactionInvocationHandler(service));

	}*/
	
}

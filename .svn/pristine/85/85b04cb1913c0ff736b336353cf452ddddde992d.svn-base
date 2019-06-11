package com.gcg.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * @author: 高春贵
 * @date: 2018年11月28日
 * @Description:自定义配置类(获取配置文件中的配置信息)
 */
@Configuration
public class MyConfig {
	@Value("${my-config.database-type}")
	private String databaseType;//允许的数据库类型
	
	@Value("${my-config.basePath}")
	private String basePath;//默认生成的模板位置
	
	@Value("${my-config.packagePrefix}")
	private String packagePrefix;//包名前缀
	
	@Value("${my-config.entityPackage}")
	private String entityPackage;//实体包名
	
	@Value("${my-config.daoPackage}")
	private String daoPackage;//dao包名
	
	@Value("${my-config.serverPackage}")
	private String serverPackage;//service包名
	
	@Value("${my-config.serverImplPackage}")
	private String serverImplPackage;//service实现类包名
	
	@Value("${my-config.controllerPackage}")
	private String controllerPackage;//controller包名
	
	public String getDatabaseType() {
		return databaseType;
	}
	public String getBasePath() {
		return basePath;
	}
	public String getPackagePrefix() {
		return packagePrefix;
	}
	public String getEntityPackage() {
		return entityPackage;
	}
	public String getDaoPackage() {
		return daoPackage;
	}
	public String getServerPackage() {
		return serverPackage;
	}
	public String getServerImplPackage() {
		return serverImplPackage;
	}
	public String getControllerPackage() {
		return controllerPackage;
	}
}

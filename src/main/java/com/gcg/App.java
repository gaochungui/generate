package com.gcg;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * @author: 高春贵
 * @date: 2018年9月25日
 * @Description:启动类
 */
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)//(相当于以下三个注解)
public class App extends SpringBootServletInitializer{
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(App.class);
    }
	
	@SuppressWarnings("all")
	public static void main(String[] args) {
		 SpringApplication.run(App.class, args);
	}
}

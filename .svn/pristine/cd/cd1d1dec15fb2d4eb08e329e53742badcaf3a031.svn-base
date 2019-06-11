package com.gcg.util;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:生成word工具类
 */
public class WordUtil {
	/**
	 * @Description:导出word
	 */
	public static boolean exportWord(Connection conn,String basePath,String fileName) throws Exception{
		//获取数据库中所有表名和表注释
		List<HashMap<String, Object>> tables=ConnectUtil.getTableNameAndRemark(conn,null);
		tables=ConnectUtil.getTables(tables, conn);
		Map<String,Object> dataMap=new HashMap<String,Object>();
		dataMap.put("tables",tables);
		dataMap.put("baseName",fileName);
		GenerateUtil.proceed(dataMap,"word.ftl",basePath+"\\word",fileName+".doc");//生成实体
		return true;
	}
}

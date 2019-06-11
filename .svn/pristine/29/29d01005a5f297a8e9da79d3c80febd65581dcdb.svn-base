package com.gcg.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * @author: 高春贵
 * @date: 2018年5月24日
 * @Description:字符串工具类
 */
public class StrUtil {
	/**
	 * @author: 高春贵
	 * @date: 2018年5月24日
	 * @Description:数据库列名转化为属性名,如DEAL_ID=dealId;
	 * 				不能保证完全正确，如DBUTIL不会智能的转化为DBUtil,而会转化为dbutil,
	 */
	public static String formatDBNameToVarName(String DBName) {
		if(isUpperCase(DBName.toCharArray()[0])){//首字母是否大写
			DBName=firstLower(DBName);
		}
		if(DBName.contains("_")){
			StringBuilder result = new StringBuilder("");
			// 以"_"分割
			String[] DBNameArr = DBName.split("_");
			for (int i = 0, j = DBNameArr.length; i < j; i++) {
				// 获取以"_"分割后的字符数组的每个元素的第一个字母，第一个小写，其他的大写
				if(i==0){
					result.append((DBNameArr[i].charAt(0)+"").toLowerCase());
				}else{
					result.append((DBNameArr[i].charAt(0)+"").toUpperCase());
				}
				// 将其他字符转换成小写
				result.append(DBNameArr[i].substring(1).toLowerCase());
			}
			char c0 = result.charAt(0);
			if (c0 >= 'A' && c0 <= 'Z')
				c0 = (char) (c0 + 'a' - 'A');
			result.setCharAt(0, c0);
			return result.toString();
		}else{
			return DBName;
		}
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年5月24日
	 * @Description:获取数据库类型对应的java类型
	 */
	public static String getJavaType(String typeName,String columnSize,String decimalDigits){
		String javaType="";
		if(("INT".equals(typeName)||"BIGINT".equals(typeName)) && Integer.parseInt(columnSize)<=10){
			javaType= "Integer";
        }else if(("INT".equals(typeName)||"BIGINT".equals(typeName)) && Integer.parseInt(columnSize)>10){
        	javaType= "Long";
        }else if("DOUBLE".equals(typeName)){
			javaType= "Double";
		}else if("DECIMAL".equals(typeName)){
        	javaType= "java.math.BigDecimal";
        }else if("NUMBER".equals(typeName) && Integer.parseInt(columnSize)<=9){
        	javaType= "Integer";
        }else if("NUMBER".equals(typeName) && Integer.parseInt(columnSize)>9 && Integer.parseInt(columnSize) <= 17 ){
        	javaType= "Long";
        }else if("NUMBER".equals(typeName) && Integer.parseInt(columnSize) >= 18 ){
        	javaType="java.math.BigDecimal";
        }else if("TEXT".equals(typeName)||"CHAR".equals(typeName)||"VARCHAR".equals(typeName)||"VARCHAR2".equals(typeName)){
        	javaType= "String";
        }else if("DATE".equals(typeName)){
			javaType= "java.sql.Date";
		}else if("DATETIME".equals(typeName)){
			javaType= "java.sql.Timestamp";
		}else if(!isEmpty(decimalDigits)&&Integer.parseInt(decimalDigits)>0){
        	javaType= "java.math.BigDecimal";
        }else if(("TINYBLOB".equals(typeName))||("BLOB".equals(typeName))||("MEDIUMBLOB".equals(typeName))||("LONGBLOB".equals(typeName))){
        	javaType="byte[]";
        }
        return javaType;
	} 
	
	/**
	 * @author: 高春贵
	 * @date: 2018年5月25日
	 * @Description:获取数据表类型对应的jdbc类型
	 */
	public static String getJdbcType(String typeName){
		String jdbcType="";
		if("INT".equals(typeName)||"BIGINT".equals(typeName)){
			jdbcType="INTEGER";
		}else if("VARCHAR".equals(typeName)||"TEXT".equals(typeName)){
			jdbcType="VARCHAR";
		}else if("DATETIME".equals(typeName)||"DATE".equals(typeName)){
			jdbcType="DATE";
		}else if("DECIMAL".equals(typeName)){
			jdbcType="DECIMAL";
		}else if("DOUBLE".equals(typeName)){
			jdbcType="DOUBLE";
		}else if("FLOAT".equals(typeName)){
			jdbcType="FLOAT";
		}
		return jdbcType;
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年5月25日
	 * @Description:字段类型拆箱操作，包装类转为基本数据类型
	 */
	public static String devanning(String type){
		String result="";
		if("Character".equals(type)){
			result="char";
		}else{
			result=type;
		}
		return result;
	}
	 /**
	 * @author: 高春贵
	 * @date: 2018年5月24日
	 * @Description:判断字符串是否为空
	 */
	public static boolean isEmpty(String string) {
        if (string == null || string.trim().length() == 0)
            return true;
        else
            return false;
    }

	/**
	 * @author: 高春贵
	 * @date: 2018年5月25日
	 * @Description:首字母大写
	 */
	public static String firstBig(String s){
		if(s==null || s.length()<=1){
			return s;
		}
		return s.substring(0,1).toUpperCase()+(s.length()>1?s.substring(1):"");
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年12月19日
	 * @Description:判断字符是否大写
	 */
	public static boolean isUpperCase(char str){
	    return str >=65 && str <= 90;
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年12月19日
	 * @Description:首字母小写
	 */
	public static String firstLower(String s){
		if(s==null || s.length()<=1){
			return s;
		}else{
			char [] chars=s.toCharArray();
			chars[0]+=32;
			return String.valueOf(chars);
		}
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:java类型设置
	 */
	public static List<HashMap<String,Object>> javaType(){
		List<HashMap<String,Object>> result=new ArrayList<HashMap<String,Object>>();
		HashMap<String, Object> map= new HashMap<String,Object>();
		map.put("key", "String"); 
		map.put("value", "String"); 
		result.add(map);
		HashMap<String, Object> map1= new HashMap<String,Object>();
		map1.put("key", "Integer"); 
		map1.put("value", "Integer"); 
		result.add(map1);
		HashMap<String, Object> map2= new HashMap<String,Object>();
		map2.put("key", "Double"); 
		map2.put("value", "Double"); 
		result.add(map2);
		HashMap<String, Object> map3= new HashMap<String,Object>();
		map3.put("key", "Long"); 
		map3.put("value", "Long"); 
		result.add(map3);
		HashMap<String, Object> map4= new HashMap<String,Object>();
		map4.put("key", "java.math.BigDecimal"); 
		map4.put("value", "BigDecimal"); 
		result.add(map4);
		HashMap<String, Object> map5= new HashMap<String,Object>();
		map5.put("key", "java.sql.Date"); 
		map5.put("value", "Date"); 
		result.add(map5);
		HashMap<String, Object> map6= new HashMap<String,Object>();
		map6.put("key", "java.sql.Timestamp"); 
		map6.put("value", "Timestamp"); 
		result.add(map6);
		return result;
	}
	public static String getDatabaseName(String database){
		database=database.substring(database.lastIndexOf("/")+1);
		System.out.println(database);
		if(database.indexOf("?")>=0){
			database=database.substring(0, database.lastIndexOf("?"));
		}
		return database;
	}
	public static void main(String[] args) {
		String a="IconPath";
		String b="jdbc:mysql://192.168.30.32:3306/network?useUnicode=true&characterEncoding=utf8";
		System.out.println(getDatabaseName(b));
	}
}

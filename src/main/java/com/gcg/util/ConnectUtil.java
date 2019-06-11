package com.gcg.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;


/**
 * @author: 高春贵
 * @date: 2018年11月30日
 * @Description:数据库连接工具类
 */
public class ConnectUtil {
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:创建数据库连接
	 */
	public static Connection getConnection(HttpServletRequest request) throws ClassNotFoundException, SQLException{
		String databaseDrive=request.getParameter("databaseDrive"); //数据库驱动
		String databaseUrl=request.getParameter("databaseUrl"); //数据库连接地址
		String databaseUser=request.getParameter("databaseUser"); //数据库用户名
		String databasePass=request.getParameter("databasePass"); //数据库密码
		
		Class.forName(databaseDrive); //数据库驱动
		return DriverManager.getConnection(databaseUrl, databaseUser, databasePass);//连接数据库
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:关闭数据库连接
	 */
	public static void colseConnection(Connection conn){
		if(conn!=null){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:获取数据库的所有表名和表注释
	 */
	public static List<HashMap<String,Object>> getTableNameAndRemark(Connection conn,String table){
		List<HashMap<String,Object>> result=new ArrayList<HashMap<String,Object>>();
		
		try {
			//获取数据库元数据相关信息对象
			DatabaseMetaData dm=conn.getMetaData();
			Statement stmt = conn.createStatement();
			// 表名列表
		    ResultSet tableSet = dm.getTables(null, null, table, new String[] { "TABLE" });
		    while (tableSet.next()) {
		    	HashMap<String,Object> map=new HashMap<String,Object>();
		    	String tableName = tableSet.getString("TABLE_NAME");//获取表名
		    	map.put("tableName", tableName);
		    	ResultSet rs = stmt.executeQuery("SHOW CREATE TABLE " + tableName);//获取建表语句
				if (rs != null && rs.next()) {
					String createDDL = rs.getString(2);
					String comment = parse(createDDL);
					map.put("remark", comment);
				}
				result.add(map);
		     }
		}catch (Exception e){
			
		}
		return result;
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:获取表注释
	 */
	public static String parse(String all) {
		String comment = null;
		int index = all.indexOf("COMMENT='");//获取表说明
		if (index < 0) {
			return "";
		}
		comment = all.substring(index + 9);
		comment = comment.substring(0, comment.length() - 1);
		if(!"".equals(comment))comment=comment.replaceAll("\\\\r\\\\n", "");//去除\r\n
		return comment;
	}
	/**
	 * @Description:获取数据库表中列信息
	 */
	public static List<HashMap<String,Object>> getTables(List<HashMap<String,Object>> tables,Connection conn) throws Exception{
		for (HashMap<String, Object> hashMap : tables) {
			//获取表名
			String tableName=hashMap.get("tableName").toString();
			//获取数据库元数据相关信息对象
			DatabaseMetaData dm=conn.getMetaData();
			//获取表主键
			ResultSet keySet=dm.getPrimaryKeys(null, null, tableName);
			Set<String> primarySet = new HashSet<String>();
			if(keySet!=null){
				while(keySet.next()){
		            primarySet.add(keySet.getString(4));
		        }
			}
			
			/** 
             * 获取可在指定类别中使用的表列的描述。 
             * 方法原型:ResultSet getColumns(String catalog,String schemaPattern,String tableNamePattern,String columnNamePattern) 
             * catalog - 表所在的类别名称;""表示获取没有类别的列,null表示获取所有类别的列。 
             * schema - 表所在的模式名称(oracle中对应于Tablespace);""表示获取没有模式的列,null标识获取所有模式的列; 可包含单字符通配符("_"),或多字符通配符("%"); 
             * tableNamePattern - 表名称;可包含单字符通配符("_"),或多字符通配符("%"); 
             * columnNamePattern - 列名称; ""表示获取列名为""的列(当然获取不到);null表示获取所有的列;可包含单字符通配符("_"),或多字符通配符("%"); 
             */ 
			List<HashMap<String,Object>> jsonArray = new ArrayList<HashMap<String,Object>>();//字段列表
			ResultSet columnSet=dm.getColumns(null, null, tableName, null);
			if(columnSet!=null){
				while (columnSet.next()) {//循环列
					 //获取列信息
					 String columnName = columnSet.getString("COLUMN_NAME");//列名
					 String columnComment = columnSet.getString("REMARKS");//列说明
					 String sqlType = columnSet.getString("TYPE_NAME");//列类型
					 String columnSize = columnSet.getString("COLUMN_SIZE");//列长度
                     String decimalDigits = columnSet.getString("DECIMAL_DIGITS");//小数位精度
					 String isNullable = columnSet.getString("IS_NULLABLE").equals("YES")?"true":"false";//是否非空约束
					 //将列信息保存在hashmap中
					 HashMap<String,Object> tableLine=new  HashMap<String,Object>();
					 tableLine.put("columnName", columnName);
					 tableLine.put("isNullable", isNullable);
					 tableLine.put("columnComment", columnComment);
					 tableLine.put("precision", decimalDigits);
					 tableLine.put("columnSize", columnSize);
					 tableLine.put("sqlType", sqlType);
					 //当前列是否是主键
					 if(primarySet.contains(columnName)){
						 tableLine.put("isPrimaryKey","true");
                     }else{
                    	 tableLine.put("isPrimaryKey","false");
                     }
					 jsonArray.add(tableLine);
				}
			}
			hashMap.put("columnList", jsonArray);
		}
		return tables;
	}
}

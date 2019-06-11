package com.gcg.controller;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.gcg.config.MyConfig;
import com.gcg.util.ConnectUtil;
import com.gcg.util.GenerateUtil;
import com.gcg.util.StrUtil;
import com.gcg.util.WordUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class GenerateController {
	@Autowired
	private MyConfig config;
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:跳转首页
	 */
	@RequestMapping("/show")
	public String show(HttpServletRequest request){
		//可操作的数据库类型
		List<String> databaseType=Arrays.asList(config.getDatabaseType().split(","));
		request.setAttribute("databaseType", databaseType);
		return "index";
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:数据库连接,返回包含的表名列表
	 */
	@ResponseBody
	@RequestMapping(value="/connect")
	public String connect(HttpServletRequest request){
		JSONObject result=new JSONObject();//结果接收
		String tableName=request.getParameter("tableName"); //数据库表名
		Connection conn=null;
		//数据库连接
		try {
			conn=ConnectUtil.getConnection(request);
			if(conn==null){
				result.put("error", "数据库连接失败，请检查数据库信息是否正确");
				return result.toString();
			}
			System.out.println("数据库连接成功");
			//获取数据库表名和说明
			List<HashMap<String, Object>> data=ConnectUtil.getTableNameAndRemark(conn,tableName);
			result.put("success", "数据库连接成功");
			result.put("data", data);
		} catch (Exception e) {
			result.put("error", "数据库连接失败，请检查数据库信息是否正确");
		}finally {
			ConnectUtil.colseConnection(conn);
			System.out.println("数据库连接关闭");
		}
		return result.toString();
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description：跳转表配置信息页
	 */
	@ResponseBody
	@RequestMapping(value="/select/{tableName}/{remark}")
	public String select(@PathVariable("tableName") String tableName,@PathVariable("remark") String remark,
			HttpServletRequest request){
		JSONObject result=new JSONObject();
		
		Connection conn=null;
		//数据库连接
		try {
			conn=ConnectUtil.getConnection(request);
			if(conn!=null){
				System.out.println("数据库连接成功");
				
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
				List<HashMap<String,Object>> jsonArray = new ArrayList<HashMap<String,Object>>();
				ResultSet columnSet=dm.getColumns(null, null, tableName, null);
				int flag=0;//主键个数
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
						 tableLine.put("tableColumnsName", columnName);
						 tableLine.put("isNullAble", isNullable);
						 tableLine.put("tableColumnsNameTf", StrUtil.formatDBNameToVarName(columnName));
						 tableLine.put("tableColumnsComment", columnComment);
						 tableLine.put("tableColumnsType", sqlType);
						 tableLine.put("tableColumnsSize", columnSize);
						 tableLine.put("tableColumnsJavaType", StrUtil.getJavaType(sqlType, columnSize, decimalDigits));
						 tableLine.put("tableColumnsDecimal", decimalDigits);
						 //当前列是否是主键
						 if(primarySet.contains(columnName)){
							 tableLine.put("isPrimaryKey","true");
							 flag+=1;
	                     }else{
	                    	 tableLine.put("isPrimaryKey","false");
	                     }
						 jsonArray.add(tableLine);
					}
				}
				result.put("list", jsonArray);//表数据列
				result.put("types", StrUtil.javaType());//获取java类型列表
				result.put("keyNum", flag);//获取java类型列表
			}
		} catch (Exception e) {
		}finally {
			ConnectUtil.colseConnection(conn);
			System.out.println("数据库连接关闭");
		}
		
		return result.toString();
	}
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:单表生成文件
	 */
	@ResponseBody
	@RequestMapping("/buildFile")
	public String buildFile(HttpServletRequest request){
		JSONObject result=new JSONObject();//结果集
		//获取参数
		String tableName=request.getParameter("tableName");//表名称
		String tableComment=request.getParameter("tableComment");//表说明
		String keyNum=request.getParameter("keyNum");//主键个数
		if(Integer.parseInt(keyNum)>1){
			result.put("error", "暂不支持多主键生成");
		}else{
			boolean entity = new Boolean(request.getParameter("entity"));
	        boolean dao = new Boolean(request.getParameter("dao"));
	        boolean mapper = new Boolean(request.getParameter("mapper"));
	        boolean service = new Boolean(request.getParameter("service"));
	        boolean controller = new Boolean(request.getParameter("controller"));
	        boolean vue = new Boolean(request.getParameter("vue"));
	        //字段参数集
	      	String buildParam = request.getParameter("buildParam");
	      	System.out.println(buildParam);
	      	JSONArray json=JSONArray.fromObject(buildParam);
	      	try {
	      		boolean generate=GenerateUtil.generate(tableName, tableComment, config.getBasePath(), entity, dao, mapper, service, controller, vue, json, keyNum,config);
	      		if(generate) result.put("success", "文件生成成功");
	    		else result.put("error", "文件生成失败");
	      	} catch (Exception e) {
	      		result.put("error", e.getClass().getName()+":"+e.getMessage());
			}
		}
      	return result.toString();
	}
	
	/**
	 * @Description:跳转导出word页面
	 */
	@RequestMapping("/word")
	public String word(HttpServletRequest request){
		return "word";
	}
	/**
	 * @Description:导出数据库结构到word
	 */
	@ResponseBody
	@RequestMapping("/exportWord")
	public String exportWord(HttpServletRequest request){
		JSONObject result=new JSONObject();//结果集
		Connection conn=null;
		//数据库连接
		try {
			conn=ConnectUtil.getConnection(request);
			if(conn==null){
				result.put("error", "数据库连接失败，请检查数据库信息是否正确");
				return result.toString();
			}
			System.out.println("数据库连接成功");
			//获取数据库表名和说明
			boolean data=WordUtil.exportWord(conn,config.getBasePath(),StrUtil.getDatabaseName(request.getParameter("databaseUrl")));
			if(data){
				result.put("success", "导出成功");
			}else{
				result.put("error", "导出失败");
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			result.put("error", "数据库连接失败，请检查数据库信息是否正确");
		}
		return result.toString();
	}
}

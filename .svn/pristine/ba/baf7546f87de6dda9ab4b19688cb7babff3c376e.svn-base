package com.gcg.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.util.ResourceUtils;

import com.gcg.config.MyConfig;

import freemarker.template.Configuration;
import freemarker.template.Template;
import net.sf.json.JSONArray;

/**
 * @author: 高春贵
 * @date: 2018年11月30日
 * @Description:生成主类
 */
public class GenerateUtil {
	
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:生成java文件到指定目录
	 * @param map参数集合 
	 * @param tempName指定的模板名称
	 * @param filePath指定的生成文件位置
	 */
	public static void proceed(Map<String, Object> map,String tempName,String folder,String fileName) throws Exception{
		//通过configuration对象获根据模板名称取到template
    	@SuppressWarnings("deprecation")
		Configuration configuration = new Configuration();
    	File file = ResourceUtils.getFile("classpath:templates/ftl");
    	 //获取模版路径
        configuration.setDirectoryForTemplateLoading(file);
        configuration.setDefaultEncoding("utf-8");
		Template template = configuration.getTemplate(tempName);
		File f = new File(folder);  
		if(!f.exists()){  
		    f.mkdirs();  
		}
		FileOutputStream outStream=new FileOutputStream(new File(folder+"\\"+fileName));
		OutputStreamWriter out=new OutputStreamWriter(outStream, "UTF-8");
		template.process(map, out);
		out.close();
		outStream.close();
	}
	/**
	 * @author: 高春贵
	 * @date: 2018年11月30日
	 * @Description:根据参数生成指定的文件
	 */
	@SuppressWarnings("unchecked")
	public static boolean generate(String tableName,String tableComment,String basePath,boolean entity,boolean dao,boolean mapper,
			boolean service,boolean controller,boolean vue,JSONArray json,String keyNum,MyConfig config) throws Exception{
		Map<String, Object> dataMap = new HashMap<String, Object>();//封装参数
		String classname=StrUtil.formatDBNameToVarName(tableName);//表名转对象名(去除_，转为驼峰)
		
		dataMap.put("tableName", tableName);//数据库表名
		dataMap.put("classname", classname);//实体类对象名
		//类名
		String className =StrUtil.firstBig(classname);
		dataMap.put("entityName", className);//实体类名
		dataMap.put("daoName", className+"Dao");//dao类名
		dataMap.put("serviceName", className+"Service");//service类名
		dataMap.put("serviceImplName", className+"ServiceImpl");//service实现类名
		dataMap.put("controllerName", className+"Controller");//controller类名
		
		//分页条件
		dataMap.put("pageStr", "limit #{limitStart,jdbcType=DECIMAL},#{limitSize,jdbcType=DECIMAL}");//dao类名
		
		
		//主键数量
		dataMap.put("keyNum", keyNum);
		//说明
		dataMap.put("remark", tableComment);
		//字段集合
		@SuppressWarnings("deprecation")
		List<Map<String,Object>> columnList=JSONArray.toList(json,Map.class);//获取列数据
		
		int repeat=0;//要重复验证的字段个数
		List<HashMap<String,Object>> validate=new ArrayList<HashMap<String,Object>>();//要验证的字段
		
		//查询条件
		List<HashMap<String,Object>> same=new ArrayList<HashMap<String,Object>>();//等值
		List<HashMap<String,Object>> like=new ArrayList<HashMap<String,Object>>();//模糊
		
		//非空验证的字段个数
		int notEmpty=0;
		
		//导入包名
		List<String> importList=new ArrayList<String>();
		int num=columnList.size();
		if(num>0){
			for (int i = 0; i < num; i++) {
				String type=columnList.get(i).get("javaType").toString();//获取java类型
				if(type.contains("Timestamp")||type.contains("Date")){
					String format="com.fasterxml.jackson.annotation.JsonFormat";
					if(!importList.contains(format))importList.add(format);
				}
				List<HashMap<String,Object>> list=StrUtil.javaType();
				int size=list.size();
				for (int j = 0; j < size; j++) {
					String key=list.get(j).get("key").toString();
					if(key.equals(type)&&key.contains(".")){
						if(!importList.contains(key))importList.add(key);
						columnList.get(i).put("javaType", list.get(j).get("value"));
					}
				}
				String javaName=columnList.get(i).get("javaName").toString();//获取对应的java字段名称
				columnList.get(i).put("name", StrUtil.firstBig(javaName));
				
				columnList.get(i).put("value","#{"+javaName+"}");//参数赋值
				columnList.get(i).put("attrValue","#{"+javaName+"_new}");//参数赋值（没有主键时设置）
				
				String sqlType=columnList.get(i).get("sqlType").toString();//获取sql类型
				
				columnList.get(i).put("jdbcType",StrUtil.getJdbcType(sqlType));//获取jdbcType
				
				if(new Boolean(columnList.get(i).get("isValidate").toString())){//是否有重复验证
					repeat+=1;
					HashMap<String, Object> map=new HashMap<String, Object>();
					map.put("name", javaName);
					map.put("bigName", StrUtil.firstBig(javaName));
					map.put("type", columnList.get(i).get("javaType"));
					map.put("comment", columnList.get(i).get("columnComment"));
					validate.add(map);
				}
				if(new Boolean(columnList.get(i).get("isPrimaryKey").toString())){//主键
					HashMap<String, Object> map=new HashMap<String, Object>();
					map.put("name", javaName);
					map.put("bigName", StrUtil.firstBig(javaName));
					map.put("type", columnList.get(i).get("javaType"));
					dataMap.put("keyMap", map);
				}
				if(new Boolean(columnList.get(i).get("isListSelect").toString())){//是否为列表查询项
					String matchingType=columnList.get(i).get("matchingType").toString();//获取匹配方式
					HashMap<String, Object> map=new HashMap<String, Object>();
					map.put("name", javaName);
					map.put("columnName", columnList.get(i).get("columnName"));
					map.put("type", columnList.get(i).get("javaType"));
					if("=".equals(matchingType)){//等值匹配
						same.add(map);
					}else{//模糊匹配
						like.add(map);
					}
				}
				if(new Boolean(columnList.get(i).get("isNotEmpty").toString())){//是否非空验证
					notEmpty+=1;
					String notNullPackage=config.getPackagePrefix()+".annotation.NotNull";
					if(!importList.contains(notNullPackage)){
						importList.add(notNullPackage);
					}
				}
			}
		}
		//查询字段
		dataMap.put("likeList", like);
		dataMap.put("sameList", same);
		
		dataMap.put("notEmpty", notEmpty);
		int size=like.size();
		StringBuffer buffer=new StringBuffer();
		if(size>0){//表示有模糊匹配的字段
			for (int k = 0; k < size; k++) {
				if(k==0)buffer.append("and (");
				buffer.append(like.get(k).get("columnName")+" like '%' #{query} '%'");
				if(size-1>k)buffer.append(" or ");
				if(k==size-1)buffer.append(")");
			}
		}
		dataMap.put("likeStr", buffer.toString());
		dataMap.put("attrs", columnList);
		dataMap.put("import", importList);
		dataMap.put("repeat", repeat);//重复验证字段的个数
		dataMap.put("validateList", validate);//重复验证字段的集合
		//包名
		dataMap.put("packagePrefix", config.getPackagePrefix());//实体包名
		dataMap.put("entityPackage", config.getEntityPackage());//实体包名
		dataMap.put("daoPackage", config.getDaoPackage());//dao包名
		dataMap.put("serverPackage", config.getServerPackage());//service包名
		dataMap.put("serverImplPackage", config.getServerImplPackage());//service实现类包名
		dataMap.put("controllerPackage", config.getControllerPackage());//controller包名
		
		if(entity)proceed(dataMap,"entity.ftl",basePath+"\\entity",className+".java");//生成实体
		if(dao)proceed(dataMap,"dao.ftl",basePath+"\\dao",className+"Dao.java");//生成dao
		if(mapper)proceed(dataMap,"mapper.ftl",basePath+"\\mapper",className+"Mapper.xml");//生成mapper文件
		if(service)proceed(dataMap,"service.ftl",basePath+"\\service",className+"Service.java");//生成service文件
		if(service)proceed(dataMap,"serviceImpl.ftl",basePath+"\\serviceImpl",className+"ServiceImpl.java");//生成service实现文件
		if(service)proceed(dataMap,"controller.ftl",basePath+"\\controller",className+"Controller.java");//生成controller文件
		return true;
	}
}

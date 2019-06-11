package ${packagePrefix}.${serverImplPackage};

import java.util.HashMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ${packagePrefix}.util.JsonResult;
import ${packagePrefix}.util.PageUtil;
import ${packagePrefix}.util.ResultCode;
import ${packagePrefix}.util.StrUtil;
import net.sf.json.JSONObject;
import ${packagePrefix}.${entityPackage}.${entityName};
import ${packagePrefix}.${daoPackage}.${daoName};
import ${packagePrefix}.${serverPackage}.${serviceName};

/**
 * @Description:${remark}
 */
@Service("${classname}Service")
@Transactional
public class ${serviceImplName} implements ${serviceName} {
	@Autowired
	private ${daoName} ${classname}Dao;
	
	/**
	 * @Description:分页查询数据
	 */
	public HashMap<String, Object> queryForPage(JSONObject obj) {
		HashMap<String,Object> result=null;
		//分页查询的参数获取与封装
		HashMap<String,Object> paramMap=new HashMap<String,Object>();
		
		//参数接收
		<#if sameList?? && (sameList?size>0)>
		<#list sameList as list>
		<#if list.type=="Integer">
		int ${list.name}=StrUtil.getIntByJSON(obj, "${list.name}");
		<#else>
		String ${list.name}=StrUtil.getStringByJSON(obj, "${list.name}");
		</#if>	
		paramMap.put("${list.name}", ${list.name});
		</#list>
		</#if>
		<#if likeList?? && (likeList?size>0)>
		String query=StrUtil.getStringByJSON(obj, "query");	
		paramMap.put("query", query);
		</#if>
		
		int start_index = (obj.get("startIndex")!=null&&!"".equals(obj.get("startIndex")))?obj.getInt("startIndex"):1;
	    <#-- int page_size = (obj.get("pageSize")!=null&&!"".equals(obj.get("pageSize")))?obj.getInt("pageSize"):10; -->
	    try {
	    	<#-- result = PageUtil.pageQuery(${classname}Dao, start_index, page_size, paramMap);-->
			result = PageUtil.pageQuery(${classname}Dao, start_index, paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
<#if keyNum!="0">
	/**
	 * @Description:根据id查询数据
	 */
	public ${entityName} select${entityName}ByKey(<#list attrs as attr><#if attr.isPrimaryKey=="true">${attr.javaType}  ${attr.javaName}</#if></#list>) {
		return ${classname}Dao.selectByKey(<#list attrs as attr><#if attr.isPrimaryKey=="true">${attr.javaName}</#if></#list>);
	}
</#if>
<#if repeat!=0>
	/**
	 * @Description:字段验证
	 */
	public String validate(JSONObject obj) {
		String result="success";//验证结果
		//获取id
	<#if keyMap.type=="Integer">
		int ${keyMap.name}=StrUtil.getIntByJSON(obj, "${keyMap.name}");
	<#else>
		String ${keyMap.name}=StrUtil.getStringByJSON(obj, "${keyMap.name}");
	</#if>
	<#list validateList as list>
		//获取${list.comment}
		String ${list.name}=StrUtil.getStringByJSON(obj, "${list.name}");
		if(!"".equals(${list.name})){
			//创建对象
			${entityName} ${classname}=new ${entityName}();
			<#if list.type=="String">
			${classname}.set${list.bigName}(${list.name});
			</#if>
			<#if list.type=="Integer">
			${classname}.set${list.bigName}(Integer.parseInt(${list.name}));
			</#if>
			${entityName} data=${classname}Dao.select(${classname});
		<#if keyMap.type=="Integer">
			if(${keyMap.name}!=0){//修改
		<#else>
			if(!"".equals(${keyMap.name})){//修改
		</#if>	
				//查询旧的数据
				${entityName} old=${classname}Dao.selectByKey(${keyMap.name});
				if(old!=null){
					if(data!=null&&!${list.name}.equals(old.get${list.bigName}()))
						result="${list.comment}已存在";
				}
			}else{//添加
				if(data!=null)result="${list.comment}已存在";
			}
		}
	</#list>
		return result;
	}
</#if>
	/**
	 * @Description:添加数据
	 */
	public JsonResult add${entityName}(JSONObject obj) {
	<#if repeat!=0>
		String validate=validate(obj);
		if(!"success".equals(validate)){//验证失败
			return new JsonResult(ResultCode.FAIL, validate);
		}else{
			${entityName} ${classname}= (${entityName}) StrUtil.JSONToObj(obj, ${entityName}.class);
			int num=${classname}Dao.insert(${classname});
			if(num>0) return new JsonResult(ResultCode.SUCCESS, "添加数据成功");
			else return new JsonResult(ResultCode.FAIL, "添加数据失败");
		}
	<#else>
		${entityName} ${classname}= (${entityName}) StrUtil.JSONToObj(obj, ${entityName}.class);
		int num=${classname}Dao.insert(${classname});
		if(num>0) return new JsonResult(ResultCode.SUCCESS, "添加数据成功");
		else return new JsonResult(ResultCode.FAIL, "添加数据失败");
	</#if>
	}
	/**
	 * @Description:修改数据
	 */
	public JsonResult update${entityName}(JSONObject obj) {
	<#if repeat!=0>
		String validate=validate(obj);
		if(!"success".equals(validate)){//验证失败
			return new JsonResult(ResultCode.FAIL, validate);
		}else{
			${entityName} ${classname}= (${entityName}) StrUtil.JSONToObj(obj, ${entityName}.class);
			int num=${classname}Dao.updateByKey(${classname});
			if(num>0) return new JsonResult(ResultCode.SUCCESS, "修改数据成功");
			else return new JsonResult(ResultCode.FAIL, "修改数据失败");
		}
	<#else>
		${entityName} ${classname}= (${entityName}) StrUtil.JSONToObj(obj, ${entityName}.class);
		int num=${classname}Dao.updateByKey(${classname});
		if(num>0) return new JsonResult(ResultCode.SUCCESS, "修改数据成功");
		else return new JsonResult(ResultCode.FAIL, "修改数据失败");
	</#if>
	}
	/**
	 * @Description:删除数据
	 */
	public JsonResult del${entityName}(JSONObject obj) {
		${entityName} ${classname}= (${entityName}) StrUtil.JSONToObj(obj, ${entityName}.class);
	<#if keyMap.type=="Integer">
		if(${classname}!=null&&${classname}.get${keyMap.bigName}()!=0){
	<#else>
		if(${classname}!=null&&!"".equals(${classname}.get${keyMap.bigName}())){
	</#if>	
			int num=${classname}Dao.delete(${classname});
			if(num>0)return new JsonResult(ResultCode.SUCCESS, "删除数据成功");
			else return new JsonResult(ResultCode.FAIL, "删除数据失败");
		}else
			return new JsonResult(ResultCode.FAIL, "请求参数异常");
	}
}

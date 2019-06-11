package ${packagePrefix}.${serverPackage};

import java.util.HashMap;
import ${packagePrefix}.util.JsonResult;
import net.sf.json.JSONObject;
import ${packagePrefix}.${entityPackage}.${entityName};

/**
 * @Description:${remark}
 */
public interface ${serviceName} {
	/**分页查询数据*/
	public HashMap<String,Object> queryForPage(JSONObject obj);
<#if keyNum!="0">
	/**根据id查询单条数据*/
	public ${entityName} select${entityName}ByKey(<#list attrs as attr><#if attr.isPrimaryKey=="true">${attr.javaType}  ${attr.javaName}</#if></#list>);
</#if>
<#if repeat!=0>
	/**数据验证*/
	public String validate(JSONObject obj);
</#if>
	/**添加数据*/
	public JsonResult add${entityName}(JSONObject obj);
	/**修改数据*/
	public JsonResult update${entityName}(JSONObject obj);
	/**删除数据*/
	public JsonResult del${entityName}(JSONObject obj);
}
package ${packagePrefix}.${controllerPackage};

import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import net.sf.json.JSONObject;
import ${packagePrefix}.util.StrUtil;
import ${packagePrefix}.${entityPackage}.${entityName};
import ${packagePrefix}.${serverPackage}.${serviceName};
import ${packagePrefix}.util.JsonResult;
import ${packagePrefix}.util.ParamUtil;
import ${packagePrefix}.util.ResultCode;
<#if notEmpty!=0>
import ${packagePrefix}.util.ValidateUtil;
</#if>

/**
 * @Description:${remark}
 */
@RestController
@RequestMapping("/${classname}Controller")
public class ${controllerName} {
	@Autowired
	private ${serviceName} ${classname}Service;
	
	/**
	 * @Description:数据加载
	 */
	@RequestMapping(value="/load",method={RequestMethod.GET})
	public JsonResult load(HttpServletRequest request){
		JSONObject obj=ParamUtil.getToJSONObject(request);
		HashMap<String,Object> map=${classname}Service.queryForPage(obj);
		if(map!=null) return new JsonResult(ResultCode.SUCCESS, "数据获取成功", map);
		else return new JsonResult(ResultCode.FAIL, "数据获取失败");
	}
	
	/**
	 * @Description:添加数据
	 */
	@RequestMapping(value="/add${entityName}",method={RequestMethod.POST})
	public JsonResult add${entityName}(HttpServletRequest request){
	<#if notEmpty!=0>
		JSONObject obj=ParamUtil.getToJSONObject(request);
		String validate=ValidateUtil.validate(obj, ${entityName}.class);
		if(!"success".equals(validate)) return new JsonResult(ResultCode.FAIL, validate);
		else return ${classname}Service.add${entityName}(obj);
	<#else>
		JSONObject obj=ParamUtil.getToJSONObject(request);
		return ${classname}Service.add${entityName}(obj);
	</#if>
	}
	
	/**
	 * @Description:查询数据
	 */
	@RequestMapping(value="/select${entityName}",method={RequestMethod.GET})
	public JsonResult select${entityName}(HttpServletRequest request){
		JSONObject obj=ParamUtil.getToJSONObject(request);
		//获取id
		String ${keyMap.name}=StrUtil.getStringByJSON(obj, "${keyMap.name}");
		if(${keyMap.name}!=null&&!"".equals(${keyMap.name})){
			${entityName} ${classname}=${classname}Service.select${entityName}ByKey(<#if keyMap.type=="Integer">Integer.parseInt(${keyMap.name})<#else>${keyMap.name}</#if>);
			if(${classname}!=null)return new JsonResult(ResultCode.SUCCESS, "数据获取成功", ${classname});
			else return new JsonResult(ResultCode.FAIL, "数据获取失败");
		}
		else return new JsonResult(ResultCode.FAIL, "请求参数异常");
	}
	
	/**
	 * @Description:修改数据
	 */
	@RequestMapping(value="/update${entityName}",method={RequestMethod.POST})
	public JsonResult update${entityName}(HttpServletRequest request){
	<#if notEmpty!=0>
		JSONObject obj=ParamUtil.getToJSONObject(request);
		String validate=ValidateUtil.validate(obj, ${entityName}.class);
		if(!"success".equals(validate)) return new JsonResult(ResultCode.FAIL, validate);
		else return ${classname}Service.update${entityName}(obj);
	<#else>
		JSONObject obj=ParamUtil.getToJSONObject(request);
		return ${classname}Service.update${entityName}(obj);
	</#if>
	}
	
	/**
	 * @Description:删除数据
	 */
	@RequestMapping(value="/del${entityName}",method={RequestMethod.POST})
	public JsonResult del${entityName}(HttpServletRequest request){
		JSONObject obj=ParamUtil.getToJSONObject(request);
		return ${classname}Service.del${entityName}(obj);
	}
<#if repeat!=0>
	/**
	 * @Description:数据验证
	 */
	@RequestMapping(value="/validate",method={RequestMethod.GET})
	public JsonResult validate(HttpServletRequest request){
		JSONObject obj=ParamUtil.getToJSONObject(request);
		String validate=${classname}Service.validate(obj);
		return new JsonResult(ResultCode.SUCCESS, validate);
	}
</#if>
}



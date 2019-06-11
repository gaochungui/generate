package ${packagePrefix}.${entityPackage};

<#if import?? && (import?size>0)>
	<#list import as im>
import ${im};
	</#list>
</#if>
/**
 * @Description:${remark}
 */
public class ${entityName}{
<#-- 循环类型及属性 -->
<#list attrs as attr>
	/**${attr.columnComment}*/
<#if attr.isNotEmpty==true>
	@NotNull(message="${attr.columnComment}不能为空")
</#if>
<#if attr.javaType=="Date">
	@JsonFormat(pattern="yyyy-MM-dd",timezone = "GMT+8")
</#if>
<#if attr.javaType=="Timestamp">
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
</#if>
    private ${attr.javaType} ${attr.javaName}; 
</#list>
<#-- 空参构造方法 -->
	public ${entityName}() {
	}
<#-- 全参构造方法 -->
	public ${entityName}(<#list attrs as attr><#if attr_index+1=attrs?size>${attr.javaType} ${attr.javaName}<#else>${attr.javaType} ${attr.javaName},</#if></#list>) {
	<#list attrs as attr>
		this.${attr.javaName}=${attr.javaName};
	</#list>
	}
<#-- setter和getter-->
<#list attrs as attr> 
	public void set${attr.name}(${attr.javaType} ${attr.javaName}){ 
		this.${attr.javaName} = ${attr.javaName}; 
	} 
	public ${attr.javaType} get${attr.name}(){ 
		return ${attr.javaName}; 
	} 
</#list>
<#-- toString -->
	public String toString() {
		return "${entityName} [<#list attrs as attr><#if attr_index=0>${attr.javaName}="+${attr.javaName}<#else>+",${attr.javaName}="+${attr.javaName}</#if></#list>+"]";
	}
}
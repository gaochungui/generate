<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packagePrefix}.${daoPackage}.${daoName}">
	<resultMap id="BaseResultMap" type="${packagePrefix}.${entityPackage}.${entityName}">
	<#list attrs as attr>
		<#if attr.isPrimaryKey=="true">
			<id column="${attr.columnName}" property="${attr.javaName}" jdbcType="${attr.jdbcType}"/>
		<#else>
			<result column="${attr.columnName}" property="${attr.javaName}" jdbcType="${attr.jdbcType}"/>
		</#if>
	</#list>
    </resultMap>
    <sql id="Base_Column_List">
    <#list attrs as attr><#if attr_index+1=attrs?size>${attr.columnName}<#else>${attr.columnName},</#if></#list>
    </sql>
    <select id="select" parameterType="${packagePrefix}.${entityPackage}.${entityName}" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List" />
        from ${tableName}
        <where>
        <#list attrs as attr>
        	<if test="${attr.javaName} != null and ${attr.javaName} != '' ">
	            and ${attr.columnName} = ${attr.value}
	        </if>
        </#list>
        </where>
    </select>
    <select id="selectList" parameterType="${packagePrefix}.${entityPackage}.${entityName}" resultType="java.util.HashMap">
        select
       	<include refid="Base_Column_List" />
        from ${tableName}
        <where>
        <#list attrs as attr>
        	<if test="${attr.javaName} != null and ${attr.javaName} != '' ">
	            and ${attr.columnName} = ${attr.value}
	        </if>
        </#list>
        </where>
    </select>
    <insert id="insert" parameterType="${packagePrefix}.${entityPackage}.${entityName}" >
        insert into ${tableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
           <#list attrs as attr>
        	<if test="${attr.javaName} != null ">
	            ${attr.columnName},
	        </if>
        	</#list>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
            <#list attrs as attr>
        	<if test="${attr.javaName} != null ">
	            ${attr.value},
	        </if>
        	</#list>
        </trim>
    </insert>
    <delete id="delete" parameterType="${packagePrefix}.${entityPackage}.${entityName}" >
        delete from ${tableName}
        <where>
        <#list attrs as attr>
        	<if test="${attr.javaName} != null and ${attr.javaName} != '' ">
	            and ${attr.columnName} = ${attr.value}
	        </if>
        </#list>
        </where>
    </delete>
<#if keyNum!="0">
	<update id="updateByKey" parameterType="${packagePrefix}.${entityPackage}.${entityName}" >
	    update ${tableName}
	    <set>
	    <#list attrs as attr>
	     	<#if attr.isPrimaryKey!="true">
        	<if test="${attr.javaName} != null ">
	            ${attr.columnName}=${attr.value},
	        </if>
	        </#if>
       	</#list>
	    </set>
	    where <#list attrs as attr><#if attr.isPrimaryKey=="true"> ${attr.columnName} =${attr.value}</#if></#list>
	</update>
	<select id="queryForPage" parameterType="java.util.HashMap" resultType="java.util.HashMap">
        <if test="countFlag != null and countFlag == 'Y'.toString() ">
        	select count(1) as totalCount from (
        </if>

	        select
	        <#list attrs as attr><#if attr.javaType=="Date">date_format(${attr.columnName},'%Y-%m-%d') ${attr.columnName}<#elseif attr.javaType=="Timestamp">date_format(${attr.columnName},'%Y-%m-%d %H:%i:%s') ${attr.columnName}<#else>${attr.columnName}</#if><#if attr_index+1=attrs?size><#else>,</#if></#list>
	        from ${tableName}
	        <where>
	        	<#list attrs as attr>
	        	<#if attr.javaType=="String">
	        	<if test="${attr.javaName} != null and ${attr.javaName} != ''">
		            and ${attr.columnName}=${attr.value}
		        </if>	
	        	<#elseif attr.javaType=="Integer"||attr.javaType=="Double"||attr.javaType=="Long">
	        	<if test="${attr.javaName} != null and ${attr.javaName} != 0">
		            and ${attr.columnName}=${attr.value}
		        </if>
	        	<#else>
	        	<if test="${attr.javaName} != null ">
		            and ${attr.columnName}=${attr.value}
		        </if>
	        	</#if>
		        </#list>
		        <#if likeList??&&(likeList?size>0)>
		      	<if test="query != null ">
		        	${likeStr}
		        </if>	
		        </#if>
	        </where>
			<#list attrs as attr><#if attr.isPrimaryKey=="true">order by ${attr.columnName} desc</#if></#list>
		
        <if test="countFlag != null and countFlag == 'N'.toString() ">
        	${pageStr}
        </if>
        <if test="countFlag != null and countFlag == 'Y'.toString() ">
        	) as TMP_COUNT_TABLE
        </if>
    </select>
    <select id="selectByKey" resultMap="BaseResultMap">
        select
        <include refid="Base_Column_List" />
        from ${tableName}
	    where <#list attrs as attr><#if attr.isPrimaryKey=="true"> ${attr.columnName} =${attr.value}</#if></#list>
    </select>
<#else>
	<update id="updateByAttr" parameterType="java.util.HashMap" >
	    update ${tableName}
	    <set>
	    <#list attrs as attr>
	     	<#if attr.isPrimaryKey!="true">
        	<if test="${attr.javaName}_new != null ">
	            ${attr.columnName}=${attr.attrValue},
	        </if>
	        </#if>
       	</#list>
	    </set>
	    <where>
	     <#list attrs as attr>
	     	<#if attr.isPrimaryKey!="true">
        	<if test="${attr.javaName} != null ">
	            ${attr.columnName}=${attr.value},
	        </if>
	        </#if>
       	</#list>	
	    </where>
	</update>
</#if>
</mapper>
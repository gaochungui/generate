package ${packagePrefix}.${daoPackage};

import java.util.List;
import java.util.HashMap;
import ${packagePrefix}.${entityPackage}.${entityName};

/**
 * @Description:${remark}
 */
public interface ${daoName}{
	/**查询单个对象*/
    public ${entityName} select(${entityName} ${classname});
    /**查询一个对象列表*/
    public List<HashMap<String,Object>> selectList(${entityName} ${classname});
    /**新增对象返回增加的数量 */
    public int insert(${entityName} ${classname});
    /** 删除对象，返回删除的数量*/
    public int delete(${entityName} ${classname});
<#if keyNum!="0">
	/**通过主键修改对象，返回修改的数量，主键不可修改 */
    public int updateByKey(${entityName} ${classname});	
	/**
     * 分页查询
     * 参数有两种情况：
     *     1、传递countFlag=Y标记,则返回的是计数
     *     2、传递countFlag=N标记、limitStart、limitSize,则返回的是分页结果,字段未驼峰化
     */
    public List<HashMap<String,Object>> queryForPage(HashMap<String,Object> paramMap);
    /** 根据主键查询单个对象*/
    public ${entityName} selectByKey(${keyMap.type}  ${keyMap.name});
<#else>
	/**通过属性修改用户信息 */
    public int updateByAttr(HashMap<String,Object> paramMap);	
</#if>

}
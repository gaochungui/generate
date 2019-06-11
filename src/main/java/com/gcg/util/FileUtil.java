package com.gcg.util;

import java.io.File;

/**
 * @author: 高春贵
 * @date: 2018年5月25日
 * @Description:文件工具类
 */
public class FileUtil {
    /**
     * @author: 高春贵
     * @date: 2018年5月25日
     * @Description:创建文件
     */
    public static boolean mkdirs(String path){
        File f = new File(path);
        f.mkdirs();
        return f.exists() && f.isDirectory();
    }
}

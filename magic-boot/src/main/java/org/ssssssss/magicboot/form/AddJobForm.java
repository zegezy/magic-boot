package org.ssssssss.magicboot.form;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;

/**
 * 新增定时任务
 */
@Getter
@Setter
public class AddJobForm {

    /**
     * 任务名称
     */
    private String jName;
    /**
     * 任务组
     */
    private String jGroup;
    /**
     * 触发器名称
     */
    private String tName;
    /**
     * 触发器组
     */
    private String tGroup;
    /**
     * cron表达式
     */
    private String cron;
    /**
     * 执行MagicAPI中的接口,原始内容，不包含code以及message信息
     * Params:
     * method – 请求方法
     */
    private String method;
    /**
     * 执行MagicAPI中的接口,原始内容，不包含code以及message信息
     * Params:
     * path – 请求路径
     */
    private String path;
    /**
     * 执行MagicAPI中的接口,原始内容，不包含code以及message信息
     * Params:
     * context – 变量信息
     */
    private Map<String,Object> context;
}

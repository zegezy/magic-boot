package org.ssssssss.magicboot.quartz;

import lombok.extern.slf4j.Slf4j;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;
import org.ssssssss.magicapi.provider.MagicAPIService;

import java.util.Date;
import java.util.HashMap;
import java.util.Optional;

/**
 * 基于magic-api接口的定时任务
 */
@Slf4j
@Component
public class MagicApiJob extends QuartzJobBean {

    @Autowired
    private MagicAPIService magicAPIService;

    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {

        /**
         * 这是一个接口任务
         * 需要执行magic-api接口的代码
         * 首先你需要配置好magic-api接口，得到接口的请求方式、请求地址、请求参数
         * 然后这个job会调用在java层调用magic-api的java代码去执行
         * 这样一个完成的基于magic-api的定时任务接口就完成了
         */

        // 获取之前保存的参数
        JobDataMap jobDataMap = context.getJobDetail().getJobDataMap();
        // 取出请求方式与路径
        String path = jobDataMap.getString("path");
        String method = jobDataMap.getString("method");
        Optional.ofNullable(path).orElseThrow(()->new RuntimeException("path 不能为空"));
        Optional.ofNullable(method).orElseThrow(()->new RuntimeException("method 不能为空"));

        // 移除请求方式与路径，剩下的都是参数
        jobDataMap.remove("path");
        jobDataMap.remove("method");

        /**
         *
         * 执行MagicAPI中的接口,原始内容，不包含code以及message信息
         * Params:
         * method – 请求方法
         * path – 请求路径
         * context – 变量信息
         */
        log.info("开始执行magicApi定时任务");
        magicAPIService.execute(method,path,jobDataMap);
        log.info("结束执行magicApi定时任务");
    }
}

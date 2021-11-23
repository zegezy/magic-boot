package org.ssssssss.magicboot.quartz;

import org.quartz.*;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ssssssss.magicboot.form.AddJobForm;
import org.ssssssss.magicboot.vo.Result;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


/**
 * 定时任务业务控制层
 */
@Service
public class ScheduledTasksService {

    @Autowired
    private Scheduler scheduler;

    /**
     * 获取所有运行中的任务
     * @return
     */
    public Result getAllJob(){
        try {
            List<AddJobForm> formList = new ArrayList<>();
            AddJobForm form = null;
            for (TriggerKey triggerKey : scheduler.getTriggerKeys(GroupMatcher.anyGroup())) {
                ///通过triggerKey在scheduler中获取trigger对象
                CronTrigger trigger = (CronTrigger)scheduler.getTrigger(triggerKey);
                JobDetail jobDetail = scheduler.getJobDetail(trigger.getJobKey());

                form = new AddJobForm();

                form.setMethod(jobDetail.getJobDataMap().getString("method"));
                form.setPath(jobDetail.getJobDataMap().getString("path"));

                jobDetail.getJobDataMap().remove("method");
                jobDetail.getJobDataMap().remove("path");

                form.setContext(jobDetail.getJobDataMap());
                form.setJName(jobDetail.getKey().getName());
                form.setJGroup(jobDetail.getKey().getGroup());

                form.setTName(trigger.getJobKey().getName());
                form.setTGroup(trigger.getJobKey().getGroup());

                formList.add(form);
            }
            return Result.isSuccess(form);

        } catch (SchedulerException e) {
            e.printStackTrace();
            return Result.isBad("获取所有任务失败：{}",e.getMessage());
        }
    }

    /**
     * 新增一个定时任务
     */
    public void addJob(AddJobForm form) {
        Optional.ofNullable(form).orElseThrow(()->new RuntimeException("参数 不能为空"));
        Optional.ofNullable(form.getPath()).orElseThrow(()->new RuntimeException("path 不能为空"));
        Optional.ofNullable(form.getMethod()).orElseThrow(()->new RuntimeException("method 不能为空"));
        Optional.ofNullable(form.getJName()).orElseThrow(()->new RuntimeException("任务名称 不能为空"));
        Optional.ofNullable(form.getTName()).orElseThrow(()->new RuntimeException("触发器名称 不能为空"));
        Optional.ofNullable(form.getCron()).orElseThrow(()->new RuntimeException("cron表达式 不能为空"));

        try {
            // 携带参数供执行job时调用
            JobDataMap newJobDataMap = new JobDataMap();
            newJobDataMap.put("method",form.getMethod());
            newJobDataMap.put("path",form.getPath());
            newJobDataMap.putAll(form.getContext());

            JobDetail jobDetail = JobBuilder.newJob(MagicApiJob.class)
                    .withIdentity(form.getJName(), form.getJGroup())
                    .setJobData(newJobDataMap)
                    .build();
            CronTrigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity(form.getTName(), form.getTGroup())
                    .usingJobData(newJobDataMap)
                    .startNow()
                    .withSchedule(CronScheduleBuilder.cronSchedule(form.getCron()))
                    .build();
            scheduler.start();
            scheduler.scheduleJob(jobDetail, trigger);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 暂停定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    public void pauseJob(String jName, String jGroup) {
        try {
            scheduler.pauseJob(JobKey.jobKey(jName, jGroup));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 继续定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    public void resumeJob(String jName, String jGroup) {
        try {
            scheduler.resumeJob(JobKey.jobKey(jName, jGroup));
        } catch (SchedulerException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    public void deleteJob(String jName, String jGroup) {
        try {
            scheduler.deleteJob(JobKey.jobKey(jName, jGroup));
        } catch (SchedulerException e) {
            e.printStackTrace();
        }
    }
}

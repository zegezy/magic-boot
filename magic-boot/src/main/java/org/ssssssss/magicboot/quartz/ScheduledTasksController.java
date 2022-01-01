package org.ssssssss.magicboot.quartz;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.ssssssss.magicboot.form.AddJobForm;
import org.ssssssss.magicboot.vo.Result;

/**
 * 定时任务控制器
 */
@Slf4j
//@Controller
@RequestMapping("/job")
public class ScheduledTasksController {

    @Autowired
    private ScheduledTasksService scheduledTasksService;

    /**
     * 获取所有运行中的任务
     * @return
     */
    @ResponseBody
    @RequestMapping("/getAllJob")
    public Result getAllJob() {
        return scheduledTasksService.getAllJob();
    }
    /**
     * 新增一个定时任务
     * @param form
     * @return
     */
    @ResponseBody
    @RequestMapping("/addJob")
    public Result addJob(AddJobForm form) {
         scheduledTasksService.addJob(form);
        return Result.isSuccess("添加定时任务 成功");
    }

    /**
     * 暂停定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    @ResponseBody
    @RequestMapping("/pauseJob")
    public Result pauseJob(String jName, String jGroup) {
        scheduledTasksService.pauseJob(jName, jGroup);
        return Result.isSuccess("暂停定时任务 成功");
    }

    /**
     * 继续定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    @ResponseBody
    @RequestMapping("/resumeJob")
    public Result resumeJob(String jName, String jGroup) {
        scheduledTasksService.resumeJob(jName, jGroup);
        return Result.isSuccess("继续定时任务 成功");
    }

    /**
     * 删除定时任务
     * @param jName 任务名
     * @param jGroup 任务组
     */
    @ResponseBody
    @RequestMapping("/resumeJob")
    public Result deleteJob(String jName, String jGroup) {
        scheduledTasksService.deleteJob(jName, jGroup);
        return Result.isSuccess("删除定时任务 成功");
    }
}

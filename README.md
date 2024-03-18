##

前端项目地址：[ **https://gitee.com/ssssssss-team/magic-boot-naive** ](https://gitee.com/ssssssss-team/magic-boot-naive)  

## 简介

基于[ **magic-api** ](https://gitee.com/ssssssss-team/magic-api)搭建的快速开发平台，前端采用Vue3 + naive-ui最新版本搭建，依赖较少，运行速度快。对常用组件进行封装。利用Vue3的`@vue/compiler-sfc`单文件编译，动态编译组件，可以实现在浏览器编写Vue代码，既改即生效快速开发，利用magic-api本身特性安全隔离生产和开发环境。将Vue代码以插件化的方式交给`magic-api`管理。  
QQ群（[ **576433387** ](https://jq.qq.com/?_wv=1027&k=KD6DPvB0)）


| 代码 | 效果 |
|----|----|
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/code.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/1.png)  |


## 功能
- 菜单管理：树结构，配置菜单、权限按钮、选择关联组件等，支持全局模糊搜索
- 组织机构：树结构，配置组织机构，类型：部门、公司（选择项存在数据字典），支持全局模糊搜索
- 角色管理：角色菜单权限分配、设置数据范围等。
- 用户管理：用户添加、导入用户（支持导入前预览数据）、登录状态更改等
- 数据字典：分为`系统类`和`业务类`两类数据维护
- 动态组件：在线编写Vue3业务页面代码，保存编译生效
- 操作日志：接口调用操作日志查询
- 登录日志：系统登录日志查询，包含登录失败日志
- 数据库监控：Druid Monitor SQL监控、数据源信息查看等
- 在线用户：当前活跃在系统内的用户，可以选择踢人下线

## 在线体验
- 演示地址：  
前台：[ **https://preview.magicboot.net/** ](https://preview.magicboot.net/)  
后台：[ **https://api.magicboot.net:8443/magic/web/index.html** ](https://api.magicboot.net:8443/magic/web/index.html)  
- 文档地址：[ **https://magicboot.net/** ](https://magicboot.net/)
- 账号：system/123456

## 系统截图
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/1.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/2.png)  |
|---|---|
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/3.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/4.png)  |
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/5.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/6.png)  |
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/7.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/8.png)  |
| ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/9.png)  | ![](https://magicboot.oss-cn-beijing.aliyuncs.com/system/10.png)  |



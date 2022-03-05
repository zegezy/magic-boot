{
  "properties" : { },
  "id" : "64ba47c2a11346e1972c63245cbf962c",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "修改登录状态",
  "createTime" : 1646490239469,
  "updateTime" : 1634729738648,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/change/login/status",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
return db.table("sys_user").column("isLogin", isLogin).where().eq("id",id).update()
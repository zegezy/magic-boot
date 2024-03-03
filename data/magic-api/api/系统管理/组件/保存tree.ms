{
  "properties" : { },
  "id" : "c01db2a3b18246c89ef1a6ad6b39342c",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "保存tree",
  "createTime" : null,
  "updateTime" : 1709468623502,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/save/tree",
  "method" : "POST",
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
return db.table("sys_dynamic_component").primary("id").saveOrUpdate({
    pid,
    name
})
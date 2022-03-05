{
  "properties" : { },
  "id" : "529cbe774ebe4565b091a30e806a5085",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1646401575406,
  "lock" : "0",
  "method" : "POST",
  "path" : "/delete",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : { }
}
================================
return db.table("sys_component").logic().where().eq("id",id).delete()
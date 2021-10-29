{
  "properties" : { },
  "id" : "c86e4f8fd4bc4d63bfaec8a53ea333cf",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1634731401903,
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
for(userId in id.split(',')){
    db.table("sys_user").logic().where().eq("id",userId).delete();
}
return true
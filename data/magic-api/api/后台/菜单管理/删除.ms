{
  "properties" : { },
  "id" : "3564ad867beb48898f85c44bd3f7aa3f",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "删除",
  "createTime" : 1634724871164,
  "updateTime" : 1634724871164,
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
return db.table("sys_menu").logic().where().eq("id",id).delete();
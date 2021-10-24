{
  "properties" : { },
  "id" : "633b78b93bba43fba785c71c1c18d7f7",
  "script" : null,
  "groupId" : "89130d496f6f467c88b22ae4a7f688eb",
  "name" : "删除",
  "createTime" : 1634724871175,
  "updateTime" : 1634724871175,
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
return db.table("sys_role").logic().where().eq("id",id).delete();
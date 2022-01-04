{
  "properties" : { },
  "id" : "633b78b93bba43fba785c71c1c18d7f7",
  "script" : null,
  "groupId" : "89130d496f6f467c88b22ae4a7f688eb",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1641276685001,
  "lock" : "0",
  "method" : "POST",
  "path" : "/delete",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "{\r\n\t\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : { }
}
================================
import '@get:/role/cache/delete' as cacheDelete
var roleId = id
cacheDelete()

db.table("sys_role_menu").where().eq("role_id",id).delete()
return db.table("sys_role").logic().where().eq("id",id).delete();
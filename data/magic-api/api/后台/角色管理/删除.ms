{
  "properties" : { },
  "id" : "633b78b93bba43fba785c71c1c18d7f7",
  "script" : null,
  "groupId" : "89130d496f6f467c88b22ae4a7f688eb",
  "name" : "删除",
  "createTime" : 1646490239530,
  "updateTime" : 1644121681716,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/delete",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "role:delete",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\n\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import '@get:/role/cache/delete' as cacheDelete
var roleId = id
cacheDelete()

db.table("sys_role_menu").where().eq("role_id",id).delete()
return db.table("sys_role").logic().where().eq("id",id).delete();
{
  "properties" : { },
  "id" : "c86e4f8fd4bc4d63bfaec8a53ea333cf",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "删除",
  "createTime" : 1646490239473,
  "updateTime" : 1644121688496,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/delete",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "user:delete",
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
import org.ssssssss.magicapi.cache.SqlCache

for(userId in id.split(',')){
    SqlCache.delete(`permissions:${userId}`)
    db.table("sys_user").logic().where().eq("id",userId).delete();
}
return true
{
  "properties" : { },
  "id" : "4f966df34dbe41ff8b9941da4671eb2d",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "获取排序号",
  "createTime" : 1634724871167,
  "updateTime" : 1634724871167,
  "lock" : "0",
  "method" : "GET",
  "path" : "/sort",
  "parameters" : [ {
    "name" : "pid",
    "value" : "",
    "description" : "",
    "required" : true,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
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
return db.selectInt("""select max(sort) + 10 from sys_menu where pid = #{pid} and is_del = '0'""") || 10;
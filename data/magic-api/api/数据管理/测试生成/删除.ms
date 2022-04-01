{
  "properties" : { },
  "id" : "5019707e422245b89e0b2bf00f9a2ec8",
  "script" : null,
  "groupId" : "7bdcc43555b9419caba2ee722e1aa2d3",
  "name" : "删除",
  "createTime" : 1648780777671,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/delete",
  "method" : "DELETE",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "data:test:delete",
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
  "requestBody" : null,
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
return db.table('t_data_test').logic().where().eq('id', id).delete()
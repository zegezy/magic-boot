{
  "properties" : { },
  "id" : "ed33e9c6270446118cf5674299778959",
  "script" : null,
  "groupId" : "376f26eb43a44a3daeafd27020a96f48",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1644121693440,
  "lock" : "0",
  "method" : "POST",
  "path" : "/delete",
  "parameters" : [ ],
  "option" : "[{\"name\":\"permission\",\"value\":\"dict:items:delete\",\"description\":\"允许拥有该权限的访问\"}]",
  "requestBody" : "{\n\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "permission" : "dict:items:delete"
  }
}
================================
return db.table("sys_dict_items").logic().where().eq("id",id).delete();
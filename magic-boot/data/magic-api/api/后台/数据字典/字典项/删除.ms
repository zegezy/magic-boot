{
  "properties" : { },
  "id" : "ed33e9c6270446118cf5674299778959",
  "script" : null,
  "groupId" : "376f26eb43a44a3daeafd27020a96f48",
  "name" : "删除",
  "createTime" : 1634735543067,
  "updateTime" : 1634735543067,
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
return db.table("sys_dict_items").logic().where().eq("id",id).delete();
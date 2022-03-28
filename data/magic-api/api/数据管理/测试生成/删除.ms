{
  "properties" : { },
  "id" : "7443f294349446289c25d4ef6fe2b499",
  "script" : null,
  "groupId" : "152b9ad78aaf49a7a8945b5de088c1da",
  "name" : "删除",
  "createTime" : 1648486052772,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/delete",
  "method" : "DELETE",
  "parameters" : [ ],
  "options" : [ ],
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
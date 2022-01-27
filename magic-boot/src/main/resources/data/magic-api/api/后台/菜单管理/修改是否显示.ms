{
  "properties" : { },
  "id" : "62020bd7a49949378e90ce2d14fef8f7",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "修改是否显示",
  "createTime" : null,
  "updateTime" : 1641482987357,
  "lock" : "0",
  "method" : "GET",
  "path" : "/change",
  "parameters" : [ ],
  "option" : "[{\"name\":\"wrap_request_parameter\",\"value\":\"data\",\"description\":\"包装请求参数到一个变量中\"}]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "wrap_request_parameter" : "data"
  }
}
================================
return db.table("sys_menu").primary("id").update(data)
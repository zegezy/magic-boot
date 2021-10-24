{
  "properties" : { },
  "id" : "695ff3257c314ea4bfa63edeaa511af0",
  "script" : null,
  "groupId" : "376f26eb43a44a3daeafd27020a96f48",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1634735495162,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
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
return db.table("sys_dict_items").primary("id").saveOrUpdate(data)
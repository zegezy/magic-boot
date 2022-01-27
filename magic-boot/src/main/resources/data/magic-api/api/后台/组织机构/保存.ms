{
  "properties" : { },
  "id" : "03c2c9614e5b47f48f61f4f7759fe353",
  "script" : null,
  "groupId" : "8295fc13678d4144bf7363c465247a50",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1641732020139,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
  "parameters" : [ ],
  "option" : "[{\"name\":\"wrap_request_parameter\",\"value\":\"data\",\"description\":\"包装请求参数到一个变量中\"}]",
  "requestBody" : "{}",
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
return db.table("sys_office").primary("id").saveOrUpdate(data);
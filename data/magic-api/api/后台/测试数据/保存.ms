{
  "properties" : { },
  "id" : "d31e3bea5666449d90fa95779adfb61f",
  "script" : null,
  "groupId" : "42d241c0bb18476f8dabf92c2e4e2324",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1642312068428,
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
return db.table("sys_test_data").primary("id").saveOrUpdate(data)
{
  "properties" : { },
  "id" : "cbf24a795f6441d6af123d6dff065e37",
  "script" : null,
  "groupId" : "c7ce65f5b3cf4aaa913f6fec7d35d176",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1644121671060,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
  "parameters" : [ ],
  "option" : "[{\"name\":\"wrap_request_parameter\",\"value\":\"data\",\"description\":\"包装请求参数到一个变量中\"},{\"name\":\"permission\",\"value\":\"dict:save\",\"description\":\"允许拥有该权限的访问\"}]",
  "requestBody" : "{\n\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "wrap_request_parameter" : "data",
    "permission" : "dict:save"
  }
}
================================
var typeCount = db.selectInt("select count(1) from sys_dict where is_del = 0 and type = #{data.type} ?{id, and id != #{data.id}}")
if(typeCount > 0){
    exit 0,'类型已存在'
}
return db.table("sys_dict").primary("id").saveOrUpdate(data)
{
  "properties" : { },
  "id" : "03c2c9614e5b47f48f61f4f7759fe353",
  "script" : null,
  "groupId" : "8295fc13678d4144bf7363c465247a50",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1644121675551,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
  "parameters" : [ ],
  "option" : "[{\"name\":\"wrap_request_parameter\",\"value\":\"data\",\"description\":\"包装请求参数到一个变量中\"},{\"name\":\"permission\",\"value\":\"office:save\",\"description\":\"允许拥有该权限的访问\"}]",
  "requestBody" : "{}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "wrap_request_parameter" : "data",
    "permission" : "office:save"
  }
}
================================
var codeCount = db.selectInt("select count(1) from sys_office where is_del = 0 and code = #{code} ?{id, and id != #{id}}")
if(codeCount > 0){
    exit 0,'机构编码已存在'
}
return db.table("sys_office").primary("id").saveOrUpdate(data);
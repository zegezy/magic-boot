{
  "properties" : { },
  "id" : "247133030553488a8871aa47b9f5e76c",
  "script" : null,
  "groupId" : "c7ce65f5b3cf4aaa913f6fec7d35d176",
  "name" : "获取排序号",
  "createTime" : 1646490239435,
  "updateTime" : 1634735056733,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/sort",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
return db.selectInt("""select max(sort) + 10 from sys_dict where is_del = '0'""") || 10;
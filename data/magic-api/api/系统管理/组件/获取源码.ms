{
  "properties" : { },
  "id" : "2e3a230acf004dcdb679ff3a46a8a20a",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "获取源码",
  "createTime" : 1709459380012,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/getSourceCode",
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
return db.selectValue("""
    select source_code from sys_dynamic_component where is_del=0 and name = #{name}
""")
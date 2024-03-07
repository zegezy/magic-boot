{
  "properties" : { },
  "id" : "f21ff197058a47e0ba1e1c6c714081ce",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "获取历史代码详情",
  "createTime" : null,
  "updateTime" : 1709805913373,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/history/detail",
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
    select source_code from sys_dynamic_component_history where id = #{id} and is_del = 0
""")
{
  "properties" : { },
  "id" : "56ed96789b1e4b649265da83a7b3b8b4",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "列表",
  "createTime" : null,
  "updateTime" : 1646401619732,
  "lock" : "0",
  "method" : "GET",
  "path" : "/list",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : { }
}
================================
return db.page("""
    select * from sys_component where 1=1
    ?{name, and name like concat('%',#{name},'%')}
""")
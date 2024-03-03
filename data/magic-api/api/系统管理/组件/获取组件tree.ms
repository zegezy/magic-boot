{
  "properties" : { },
  "id" : "8ba14d61082e4ba69324fdc9de080f38",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "获取组件tree",
  "createTime" : null,
  "updateTime" : 1709459290517,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/tree",
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
var toTree = (list,pid) => select t.*,toTree(list,t.id) children from list t where t.pid = pid
var list = toTree(db.select('select id,name,pid from sys_dynamic_component where is_del = 0 order by name'),'0')

return {
    list: list,
    total: list.getLength()
}
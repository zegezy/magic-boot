{
  "properties" : { },
  "id" : "f7fa03a5d8b64dbaa39387c185a21adb",
  "script" : null,
  "groupId" : "8295fc13678d4144bf7363c465247a50",
  "name" : "列表",
  "createTime" : null,
  "updateTime" : 1641731964401,
  "lock" : "0",
  "method" : "GET",
  "path" : "/tree",
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
var toTree = (list,pid) => select t.*,toTree(list,t.id) children from list t where t.pid = pid
var list = toTree(db.select('select id,name,pid,type,sort,code from sys_office where is_del = 0 order by sort'),'0')

return {
    list: list,
    total: list.getLength()
}
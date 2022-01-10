{
  "properties" : { },
  "id" : "0adb88c728814db88b901701faa56161",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "搜索菜单数据",
  "createTime" : null,
  "updateTime" : 1641828392961,
  "lock" : "0",
  "method" : "GET",
  "path" : "/search",
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
var list = toTree(db.select('select id,name as label,pid,url from sys_menu where is_del = 0 and is_show = 1 order by sort'),'0')

return {
    list: list,
    total: list.getLength()
}
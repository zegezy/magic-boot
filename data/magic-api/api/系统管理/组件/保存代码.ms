{
  "properties" : { },
  "id" : "ac35656c8123461e8c01e5bfa604a0ee",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "保存代码",
  "createTime" : null,
  "updateTime" : 1709621424466,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/saveCode",
  "method" : "POST",
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

if(db.selectInt("select count(1) from sys_dynamic_component where id = #{id} and is_del = 0") == 0){
    exit 0, '文件不存在'
}

return db.table("sys_dynamic_component").where().eq("id",id).update({
    sourceCode,
    compileJs,
    compileCss
})
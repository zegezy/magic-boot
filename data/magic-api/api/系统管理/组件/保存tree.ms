{
  "properties" : { },
  "id" : "c01db2a3b18246c89ef1a6ad6b39342c",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "保存tree",
  "createTime" : null,
  "updateTime" : 1709539934808,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/save/tree",
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
let data
if(id){
    data = {id, name}
    if(db.selectInt("select count(1) from sys_dynamic_component where is_del = 0 and name = #{name} and id != #{id}") > 0){
        exit 0, '名称不能重复'
    }
}else{
    data = {pid, name}
    if(db.selectInt("select count(1) from sys_dynamic_component where is_del = 0 and name = #{name}") > 0){
        exit 0, '名称不能重复'
    }
}
return db.table("sys_dynamic_component").primary("id").saveOrUpdate(data)
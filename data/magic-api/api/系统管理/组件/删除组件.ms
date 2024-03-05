{
  "properties" : { },
  "id" : "da1bbeb256cf417cb26aaf2426ed58c3",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "删除组件",
  "createTime" : null,
  "updateTime" : 1709540925818,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/delete",
  "method" : "DELETE",
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

let recursionDelete = (list) => {
    list.forEach(it => {
        db.table("sys_dynamic_component").logic().where().eq("id",it.id).delete()
        let children = db.select("select id from sys_dynamic_component where is_del = 0 and pid = #{it.id}")
        if(children && children.size() > 0){
            recursionDelete(children)
        }
    })
}
recursionDelete(db.select("select id from sys_dynamic_component where is_del = 0 and pid = #{id}"))

return db.table("sys_dynamic_component").logic().where().eq("id",id).delete()
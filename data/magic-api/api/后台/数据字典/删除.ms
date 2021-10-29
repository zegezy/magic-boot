{
  "properties" : { },
  "id" : "46d45f15b5ab4de7b6718fd0c9b05e7b",
  "script" : null,
  "groupId" : "c7ce65f5b3cf4aaa913f6fec7d35d176",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1634734751223,
  "lock" : "0",
  "method" : "POST",
  "path" : "/delete",
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
db.table("sys_dict_items").logic().where().eq("dictId",id).delete()
return db.table("sys_dict").logic().where().eq("id",id).delete()
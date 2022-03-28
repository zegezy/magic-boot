{
  "properties" : { },
  "id" : "f0e1cfcf4f254e17b75d7647f4f09f25",
  "script" : null,
  "groupId" : "152b9ad78aaf49a7a8945b5de088c1da",
  "name" : "详情",
  "createTime" : 1648486052778,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/get",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : null,
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
return db.selectOne("""
    select id,name,sex,head_portrait,remarks from t_data_test where id = #{id}
""")
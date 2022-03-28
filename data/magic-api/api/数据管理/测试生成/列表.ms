{
  "properties" : { },
  "id" : "90986654bb2d4560ada10c309195f500",
  "script" : null,
  "groupId" : "152b9ad78aaf49a7a8945b5de088c1da",
  "name" : "列表",
  "createTime" : 1648486052761,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/list",
  "method" : "POST",
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
return db.page("""
    select id,name,sex,head_portrait,remarks from t_data_test where 1=1
    ?{name, and name like concat('%',#{name},'%') }
    ?{sex, and sex = #{sex} }
    ?{headPortrait, and head_portrait in(#{headPortrait.split(',')}) }
    ?{remarks, and remarks <= #{remarks} }
""")
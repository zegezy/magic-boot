{
  "properties" : { },
  "id" : "33639781fde24f32902b486bd0edd6ca",
  "script" : null,
  "groupId" : "7bdcc43555b9419caba2ee722e1aa2d3",
  "name" : "列表",
  "createTime" : 1648780777658,
  "updateTime" : null,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/list",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "data:test:view",
    "description" : "允许拥有该权限的访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
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
    and is_del = 0
""")
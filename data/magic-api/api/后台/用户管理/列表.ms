{
  "properties" : { },
  "id" : "4399f2eb199b46448aa98682fe792667",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "列表",
  "createTime" : null,
  "updateTime" : 1642086792944,
  "lock" : "0",
  "method" : "GET",
  "path" : "/list",
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
return db.page("""
    select
        su.id,
        su.username,
        su.name,
        su.is_login,
        su.phone,
        su.create_date,
        su.office_id
    from sys_user su
    where su.is_del = 0
    ?{officeId, and su.office_id = #{officeId}}
    ?{username, and su.username like concat('%',#{username},'%')}
    ?{name, and su.name like concat('%',#{name},'%')}
    ?{isLogin, and su.is_login = #{isLogin}}
    order by ${orderBy || 'su.create_date desc'}
""")
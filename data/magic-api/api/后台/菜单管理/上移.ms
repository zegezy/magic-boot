{
  "properties" : { },
  "id" : "9817f2dbbc20419298e07bc644387f91",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "上移",
  "createTime" : 1646490239503,
  "updateTime" : 1641564601649,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/sort/up",
  "method" : "GET",
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
var top = db.selectOne("""
    SELECT
        id,
        sort
    FROM
        sys_menu 
    WHERE
        is_del = 0 
        AND pid = #{pid}
        AND sort < ( SELECT sort FROM sys_menu WHERE is_del = 0 AND id = #{id} ) 
    ORDER BY
        sort DESC 
        LIMIT 1
""")
if(top){
    db.update("""
        update sys_menu set sort = #{top.sort} where id = #{id}
    """)
    db.update("""
        update sys_menu set sort = #{sort} where id = #{top.id}
    """)
}
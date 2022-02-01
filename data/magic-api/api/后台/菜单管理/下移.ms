{
  "properties" : { },
  "id" : "77d393db826d4ba882b7c4b1d32e2e98",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "下移",
  "createTime" : null,
  "updateTime" : 1641564596885,
  "lock" : "0",
  "method" : "GET",
  "path" : "/sort/down",
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
var top = db.selectOne("""
    SELECT
        id,
        sort
    FROM
        sys_menu 
    WHERE
        is_del = 0 
        AND pid = #{pid}
        AND sort > ( SELECT sort FROM sys_menu WHERE is_del = 0 AND id = #{id} )
    ORDER BY
        sort 
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
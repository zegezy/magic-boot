{
  "properties" : { },
  "id" : "5f8edf5b8045475f92049270bcf0739a",
  "script" : null,
  "groupId" : "8295fc13678d4144bf7363c465247a50",
  "name" : "下移",
  "createTime" : null,
  "updateTime" : 1641737498723,
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
        sys_office 
    WHERE
        is_del = 0 
        AND pid = #{pid}
        AND sort > ( SELECT sort FROM sys_office WHERE is_del = 0 AND id = #{id} )
    ORDER BY
        sort 
        LIMIT 1
""")
if(top){
    db.update("""
        update sys_office set sort = #{top.sort} where id = #{id}
    """)
    db.update("""
        update sys_office set sort = #{sort} where id = #{top.id}
    """)
}
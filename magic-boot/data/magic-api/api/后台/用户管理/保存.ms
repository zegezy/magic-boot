{
  "properties" : { },
  "id" : "877918736c764253a85d0780cbd5f763",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1634730816739,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
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
import 'cn.dev33.satoken.secure.SaSecureUtil';

var user = {
    id,
    name,
    username,
    password: SaSecureUtil.sha256(password),
    phone,
    isLogin
}
if(id){
    db.update("""
        delete from sys_user_role where user_id = #{id}
    """)
}
id = db.table("sys_user").primary("id").saveOrUpdate(user)
for(roleId in roles.split(',')){
    db.table("sys_user_role").column('userId', id).column("roleId", roleId).insert()
}
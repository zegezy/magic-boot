{
  "properties" : { },
  "id" : "ebe40a0cf4b84192b6bbe923a0ecbd9c",
  "script" : null,
  "groupId" : "4f0230049d7e4f39b1e0897cc0f46f9a",
  "name" : "个人信息修改",
  "createTime" : null,
  "updateTime" : 1643713357950,
  "lock" : "0",
  "method" : "POST",
  "path" : "/center/update",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "{\r\n\t\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : { }
}
================================
import cn.dev33.satoken.secure.SaSecureUtil;

var data = {
    id,
    phone,
    headPortrait
}
if(newPassword){
    data.password = newPassword ? SaSecureUtil.sha256(newPassword) : ''
}
return db.table('sys_user').primary('id').update(data, true)
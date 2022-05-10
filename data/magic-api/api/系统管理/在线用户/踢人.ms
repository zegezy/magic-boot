{
  "properties" : { },
  "id" : "01fb971510764df3be20209905e86fab",
  "script" : null,
  "groupId" : "d95a58e77d314370862ffc4cdfdb8283",
  "name" : "踢人",
  "createTime" : null,
  "updateTime" : 1652170543213,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "/logout",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ {
    "name" : "permission",
    "value" : "online:logout",
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
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null
}
================================
import cn.dev33.satoken.stp.StpUtil
return StpUtil.logoutByTokenValue(token);
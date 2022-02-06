{
  "properties" : { },
  "id" : "c97e92eef5024994a32352cddbe73d6d",
  "script" : null,
  "groupId" : "1952f25c81084e24b55b11385767dc38",
  "name" : "获取当前用户权限code",
  "createTime" : null,
  "updateTime" : 1644121674755,
  "lock" : "0",
  "method" : "POST",
  "path" : "/permissions",
  "parameters" : [ ],
  "option" : "[{\"name\":\"\",\"value\":\"\",\"description\":\"\"}]",
  "requestBody" : "{\n\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": [\"sys:test:aaa\", \"menu:save\", \"menu:delete\", \"office:office:list\", \"office:office:save\", \"office:office:delete\", \"role:view\", \"role:save\", \"role:delete\", \"user:save\", \"user:delete\", \"dict:view\", \"dict:save\", \"dict:delete\", \"dict:items\", \"dict:items:save\", \"dict:items:delete\"],\n    \"timestamp\": 1641199273283,\n    \"executeTime\": 1\n}",
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : {
    "name" : "",
    "value" : "",
    "description" : "",
    "required" : false,
    "dataType" : "Object",
    "type" : null,
    "defaultValue" : null,
    "validateType" : "",
    "error" : "",
    "expression" : "",
    "children" : [ {
      "name" : "code",
      "value" : "200",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "message",
      "value" : "success",
      "description" : "",
      "required" : false,
      "dataType" : "String",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "data",
      "value" : "",
      "description" : "",
      "required" : false,
      "dataType" : "Array",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ {
        "name" : "",
        "value" : "sys:test:aaa",
        "description" : "",
        "required" : false,
        "dataType" : "String",
        "type" : null,
        "defaultValue" : null,
        "validateType" : "",
        "error" : "",
        "expression" : "",
        "children" : [ ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1641199273283",
      "description" : "",
      "required" : false,
      "dataType" : "Long",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "executeTime",
      "value" : "1",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    } ]
  },
  "optionMap" : {
    "" : ""
  }
}
================================
import 'cn.dev33.satoken.stp.StpUtil';

var userId = StpUtil.getLoginId()
return db.cache(`permissions:${userId}`).select("""
    SELECT DISTINCT
        sm.permission
    FROM
        sys_menu sm
        right JOIN sys_role_menu srm ON sm.id = srm.menu_id
        right JOIN sys_user_role sur ON sur.role_id = srm.role_id
        right JOIN sys_user su ON su.id = sur.user_id
        ?{userId != '1', AND su.id = #{userId}}
        AND su.is_del = 0
    WHERE
        sm.is_del = 0
        AND sm.permission != ''
        AND sm.permission IS NOT NULL
""").map((it) => {return it.permission})
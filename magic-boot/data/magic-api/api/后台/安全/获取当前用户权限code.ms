{
  "properties" : { },
  "id" : "c97e92eef5024994a32352cddbe73d6d",
  "script" : null,
  "groupId" : "1952f25c81084e24b55b11385767dc38",
  "name" : "获取当前用户权限code",
  "createTime" : 1634724871163,
  "updateTime" : 1634724871163,
  "lock" : "0",
  "method" : "POST",
  "path" : "/permissions",
  "parameters" : [ ],
  "option" : "[{\"name\":\"\",\"value\":\"\",\"description\":\"\"}]",
  "requestBody" : "{\r\n\t\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": [\n        \"role:view\",\n        \"role:save\",\n        \"role:delete\",\n        \"menu:delete\",\n        \"office:office:list\",\n        \"office:office:save\",\n        \"office:office:delete\",\n        \"dict:items:delete\",\n        \"sys:test:aaa\",\n        \"dict:delete\",\n        \"dict:items\",\n        \"dict:save\",\n        \"user:save\",\n        \"dict:view\",\n        \"user:delete\",\n        \"menu:save\",\n        \"dict:items:save\"\n    ],\n    \"timestamp\": 1634092982336,\n    \"executeTime\": 25\n}",
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
        "value" : "role:view",
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
      "value" : "1634092982336",
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
      "value" : "25",
      "description" : "",
      "required" : false,
      "dataType" : "Integer",
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
return db.select("""
    SELECT DISTINCT
        sm.permission
    FROM
        sys_menu sm
        left JOIN sys_role_menu srm ON sm.id = srm.menu_id
        left JOIN sys_user_role sur ON sur.role_id = srm.role_id
        left JOIN sys_user su ON su.id = sur.user_id
        ?{userId != '1', AND su.id = #{userId}}
        AND su.is_del = 0
    WHERE
        sm.is_del = 0
        AND sm.permission != ''
        AND sm.permission IS NOT NULL
""").map((it) => {return it.permission})
{
  "properties" : { },
  "id" : "6f604c0abbe446b381381ae929026a28",
  "script" : null,
  "groupId" : "1952f25c81084e24b55b11385767dc38",
  "name" : "登录",
  "createTime" : null,
  "updateTime" : 1646544815203,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/login",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ {
    "name" : "require_login",
    "value" : "false",
    "description" : "该接口需要登录才允许访问",
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
  "requestBody" : "{\r\n    \"username\": \"admin\",\r\n    \"password\": \"123456\"\r\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\"code\":200,\"message\":\"success\",\"data\":\"60f0ddf8-c42c-4b3e-802f-7482f6bd1075\",\"timestamp\":1646493023758,\"executeTime\":316}",
  "description" : null,
  "requestBodyDefinition" : {
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
      "name" : "username",
      "value" : "admin",
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
      "name" : "password",
      "value" : "123456",
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
  },
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
      "value" : "60f0ddf8-c42c-4b3e-802f-7482f6bd1075",
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
      "name" : "timestamp",
      "value" : "1646493023758",
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
      "value" : "316",
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
  }
}
================================
import log
import 'cn.dev33.satoken.secure.SaSecureUtil';
import 'cn.dev33.satoken.stp.StpUtil';
import env;
import request;

var user
if(env.get('super-password') == body.password){
    user = db.table("sys_user").where().eq("username",body.username).selectOne()
}else{
    user = db.table("sys_user").where().eq("username",body.username).eq("password",SaSecureUtil.sha256(body.password)).selectOne()
}

var loginLog = {
    username: body.username,
    type: '成功',
    ip: request.getClientIP()
}

if(!user){
    loginLog.failPassword = body.password
    db.table("sys_login_log").primary("id").save(loginLog);
    exit 0,'用户名或密码错误'
}
db.table("sys_login_log").primary("id").save(loginLog);

StpUtil.login(user.id)
return StpUtil.getTokenValueByLoginId(user.id)
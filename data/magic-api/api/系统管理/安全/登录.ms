{
  "properties" : { },
  "id" : "6f604c0abbe446b381381ae929026a28",
  "script" : null,
  "groupId" : "1952f25c81084e24b55b11385767dc38",
  "name" : "登录",
  "createTime" : null,
  "updateTime" : 1648307403240,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/login",
  "method" : "POST",
  "parameters" : [ {
    "name" : "username",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "password",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  }, {
    "name" : "code",
    "value" : null,
    "description" : null,
    "required" : false,
    "dataType" : "String",
    "type" : null,
    "defaultValue" : null,
    "validateType" : null,
    "error" : null,
    "expression" : null,
    "children" : null
  } ],
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
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": \"cb63a01c-63d7-4722-a2c4-48fffa4b3502\",\n    \"timestamp\": 1647395770056,\n    \"executeTime\": 20\n}",
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
      "value" : "cb63a01c-63d7-4722-a2c4-48fffa4b3502",
      "description" : "",
      "required" : false,
      "dataType" : "Object",
      "type" : null,
      "defaultValue" : null,
      "validateType" : "",
      "error" : "",
      "expression" : "",
      "children" : [ ]
    }, {
      "name" : "timestamp",
      "value" : "1647395770056",
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
      "value" : "20",
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
import org.ssssssss.magicboot.utils.AddressUtil
import log
import 'cn.dev33.satoken.secure.SaSecureUtil';
import 'cn.dev33.satoken.stp.StpUtil';
import env;
import request;
import org.ssssssss.magicboot.model.CodeCacheMap
import cn.hutool.http.useragent.UserAgentUtil
import cn.hutool.http.useragent.UserAgent

UserAgent ua = UserAgentUtil.parse(request.getHeaders("User-Agent")[0])

if(body.code != CodeCacheMap.get(body.uuid)){
    exit 0, '验证码错误'
}

var user
if(env.get('super-password') == body.password){
    user = db.table("sys_user").where().eq("username",body.username).selectOne()
}else{
    user = db.table("sys_user").where().eq("username",body.username).eq("password",SaSecureUtil.sha256(body.password)).selectOne()
}

var loginLog = {
    username: body.username,
    type: '成功',
    ip: request.getClientIP(),
    browser: ua.getBrowser().toString(),
    os: ua.getOs().toString(),
    address: AddressUtil.getAddress(request.getClientIP())
}

if(!user){
    loginLog.failPassword = body.password
    loginLog.type = '失败'
    db.table("sys_login_log").primary("id").save(loginLog);
    exit 0,'用户名或密码错误'
}

StpUtil.login(user.id)
var token = StpUtil.getTokenValueByLoginId(user.id)
loginLog.token = token
db.table("sys_login_log").primary("id").save(loginLog);
CodeCacheMap.remove(body.uuid)
return StpUtil.getTokenValueByLoginId(user.id)
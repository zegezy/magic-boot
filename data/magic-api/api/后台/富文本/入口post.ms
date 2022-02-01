{
  "properties" : { },
  "id" : "c9e512bc233f4b53822f9a1d94e074ff",
  "script" : null,
  "groupId" : "7eeba36706c24c1484ee4e84ad829f9b",
  "name" : "入口post",
  "createTime" : null,
  "updateTime" : 1635927291775,
  "lock" : "0",
  "method" : "POST",
  "path" : "/main",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "require_login" : "false"
  }
}
================================
import response;
return response.dispatcher(`/ueditor/${action}`);
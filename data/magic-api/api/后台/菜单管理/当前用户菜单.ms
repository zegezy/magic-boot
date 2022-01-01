{
  "properties" : { },
  "id" : "f608811b430f4a3cb82feed4067cde71",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "当前用户菜单",
  "createTime" : null,
  "updateTime" : 1641016811595,
  "lock" : "0",
  "method" : "POST",
  "path" : "/current/menus",
  "parameters" : [ ],
  "option" : "[]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 402,\n    \"message\": \"凭证已过期\",\n    \"data\": null,\n    \"timestamp\": 1641016803295,\n    \"executeTime\": null\n}",
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
      "value" : "402",
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
      "value" : "凭证已过期",
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
      "value" : "null",
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
      "value" : "1641016803295",
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
      "value" : "null",
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
  "optionMap" : { }
}
================================
import 'cn.dev33.satoken.stp.StpUtil';

var userId = StpUtil.getLoginId()
var menus = db.select("""
    SELECT DISTINCT
        sm.id,
        sm.name,
        sm.pid,
        sm.is_show,
        sm.url,
        sm.sort,
        sm.icon
    FROM
        sys_menu sm
        left JOIN sys_role_menu srm ON sm.id = srm.menu_id
        left JOIN sys_user_role sur ON sur.role_id = srm.role_id
        left JOIN sys_user su ON su.id = sur.user_id 
        ?{userId != '1', AND su.id = #{userId}} and su.is_del = 0 where sm.is_del = 0 and sm.is_show = 1 order by sort
""")

for(menu in menus){
    menu.component = (menu.url || "Layout");
    menu.path = (menu.component == 'Layout' ? "/" : menu.component);
    menu.meta = {}
    menu.meta.title = menu.name
    menu.meta.icon = menu.icon
}
var nodes = menus.toMap(it => it.id)
nodes.each((key, node) => {
    if (nodes.containsKey(node.pid)) {
        nodes[node.pid].redirect = "noRedirect";
        nodes[node.pid].component = "Layout";
        nodes[node.pid].alwaysShow = true;
        if(!nodes[node.pid].children){
            nodes[node.pid].children = []
        }
        nodes[node.pid].children.push(node)
    }
})
var treeNodes = []
nodes.each((key, node) => {
    if(node.pid == '0'){
        treeNodes.push(node)
    }
})

return treeNodes
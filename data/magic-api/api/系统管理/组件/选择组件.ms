{
  "properties" : { },
  "id" : "eb2b08bc7fe74036867e8dc5f2c0e8f8",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "选择组件",
  "createTime" : null,
  "updateTime" : 1655521303906,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/select",
  "method" : "GET",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 500,\n    \"message\": \"系统内部出现错误\",\n    \"data\": null,\n    \"timestamp\": 1655521300755,\n    \"executeTime\": 17\n}",
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
      "value" : "500",
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
      "value" : "系统内部出现错误",
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
      "value" : "1655521300755",
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
      "value" : "17",
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
import org.ssssssss.magicapi.utils.PathUtils
import org.ssssssss.magicapi.core.service.MagicResourceService
var getFiles = (groupId) => {
    return MagicResourceService.listFiles(groupId).map(file => { 
        value: PathUtils.replaceSlash(String.format("%s/%s", MagicResourceService.getGroupPath(file.groupId), file.path)).replace(/^\//,'').replace(/\/\//, '/').replace('/', '-'),
        label: `${file.name}(${file.path})`
    })
}
var toTree = (children) => {
    var treeData = []
    children.forEach(it => {
        var chi = {}
        chi.value = it.node.id
        chi.label = `${it.node.name}(${it.node.path})`
        if(it.children.length > 0){
            chi.children = toTree(it.children)
            var files = getFiles(it.node.id)
            if(files.length > 0){
                chi.children.addAll(files)
            }
        }else{
            var files = getFiles(it.node.id)
            if(files.length > 0){
                chi.children = files
            }
        }
        if(chi instanceof List){
            treeData.addAll(chi)
        }else{
            treeData.add(chi)
        }
    }) 
    return treeData
}
return toTree(MagicResourceService.tree('component').children)
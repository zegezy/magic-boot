{
  "properties" : { },
  "id" : "cc20896df1c546fba56929cc75cb0309",
  "script" : null,
  "groupId" : "fd3d225a1cf141bf9998c4ec4bf4a6ab",
  "name" : "上传",
  "createTime" : null,
  "updateTime" : 1643706737853,
  "lock" : "0",
  "method" : "POST",
  "path" : "/upload",
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
import org.ssssssss.magicboot.utils.FileUtils
import request;

var map = FileUtils.saveFile(request.getFile('file'));

db.table("sys_file").primary("id").saveOrUpdate({
    url: map.url,
    externalId: externalId,
    externalType: externalType
})

return map;
{
  "properties" : { },
  "id" : "a18a418e9d2a437dbdb51191340086c9",
  "script" : null,
  "groupId" : "fd3d225a1cf141bf9998c4ec4bf4a6ab",
  "name" : "删除",
  "createTime" : null,
  "updateTime" : 1635075573670,
  "lock" : "0",
  "method" : "GET",
  "path" : "/delete",
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
import 'java.net.URLDecoder'
import 'org.ssssssss.magicboot.model.Global'
import 'org.ssssssss.magicboot.utils.FileUtils'

url = URLDecoder.decode(url, "UTF-8");

db.table("sys_file").where().eq("url",url).delete()

String realPath = Global.getUserFilesBaseDir() + "/" + url;
FileUtil.del(realPath);

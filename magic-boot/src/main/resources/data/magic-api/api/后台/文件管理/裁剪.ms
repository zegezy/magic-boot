{
  "properties" : { },
  "id" : "874aea2c17ca4c79bcdff3d4cc458c87",
  "script" : null,
  "groupId" : "fd3d225a1cf141bf9998c4ec4bf4a6ab",
  "name" : "裁剪",
  "createTime" : null,
  "updateTime" : 1635075977442,
  "lock" : "0",
  "method" : "POST",
  "path" : "/cropper",
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
import 'org.ssssssss.magicboot.model.Global'
import 'org.ssssssss.magicboot.utils.FileUtils'

url = URLDecoder.decode(url, "UTF-8");
String realPath = Global.getUserFilesBaseDir() + "/" + url;
FileUtil.del(realPath);

var map = FileUtils.saveFile(request.getFile('file'));

db.table("sys_file").column("url", map.url).where().eq("url", url).update()

return map
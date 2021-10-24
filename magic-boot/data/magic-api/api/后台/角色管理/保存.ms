{
  "properties" : { },
  "id" : "f9a5956afdfd4492966b1a3c04dbadf6",
  "script" : null,
  "groupId" : "89130d496f6f467c88b22ae4a7f688eb",
  "name" : "保存",
  "createTime" : null,
  "updateTime" : 1634730841303,
  "lock" : "0",
  "method" : "POST",
  "path" : "/save",
  "parameters" : [ ],
  "option" : "[{\"name\":\"\",\"value\":\"\",\"description\":\"\"}]",
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : null,
  "description" : null,
  "requestBodyDefinition" : null,
  "responseBodyDefinition" : null,
  "optionMap" : {
    "" : ""
  }
}
================================
var role = {
    type,
    name,
    sort,
    id
}
if(id){
    db.table("sys_role_menu").where().eq("role_id",id).delete()
}
id = db.table("sys_role").primary("id").saveOrUpdate(role);
for(menuId in menus.split(',')){
    db.table("sys_role_menu").column("menu_id",menuId).column("role_id", id).insert();
}
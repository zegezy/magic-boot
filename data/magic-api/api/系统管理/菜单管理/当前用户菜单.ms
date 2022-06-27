{
  "properties" : { },
  "id" : "f608811b430f4a3cb82feed4067cde71",
  "script" : null,
  "groupId" : "67b2ce258e24491194b74992958c74aa",
  "name" : "当前用户菜单",
  "createTime" : null,
  "updateTime" : 1656340766427,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/current/menus",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "{\n\n}",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": [{\n        \"id\": \"b1851d1b13594e71840103c11a37a669\",\n        \"name\": \"系统设置\",\n        \"pid\": \"0\",\n        \"isShow\": 1,\n        \"url\": \"/system\",\n        \"sort\": 10,\n        \"icon\": \"settings\",\n        \"keepAlive\": 0,\n        \"code\": null,\n        \"componentname\": null,\n        \"component\": \"Layout\",\n        \"path\": \"/system\",\n        \"meta\": {\n            \"title\": \"系统设置\",\n            \"icon\": \"settings\",\n            \"keepAlive\": false\n        },\n        \"redirect\": \"noRedirect\",\n        \"alwaysShow\": true,\n        \"children\": [{\n            \"id\": \"39be13ef6f0745568c80bf35202ddb2b\",\n            \"name\": \"菜单管理\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/menu/menu-list\",\n            \"sort\": 10,\n            \"icon\": \"menu\",\n            \"keepAlive\": 1,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/menu/menu-list\",\n            \"path\": \"/system/menu/menu-list\",\n            \"meta\": {\n                \"title\": \"菜单管理\",\n                \"icon\": \"menu\",\n                \"keepAlive\": true\n            }\n        }, {\n            \"id\": \"6f3594d0-5445-41e1-a13c-890a57485036\",\n            \"name\": \"组织机构\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/office/office-list\",\n            \"sort\": 20,\n            \"icon\": \"office\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/office/office-list\",\n            \"path\": \"/system/office/office-list\",\n            \"meta\": {\n                \"title\": \"组织机构\",\n                \"icon\": \"office\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"8e9455740091486c914495cfb0c7faa5\",\n            \"name\": \"角色管理\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/role/role-list\",\n            \"sort\": 40,\n            \"icon\": \"role\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/role/role-list\",\n            \"path\": \"/system/role/role-list\",\n            \"meta\": {\n                \"title\": \"角色管理\",\n                \"icon\": \"role\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"06b8a427e4cd4c1ba11752070f565f20\",\n            \"name\": \"用户管理\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/user/user-list\",\n            \"sort\": 50,\n            \"icon\": \"user\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/user/user-list\",\n            \"path\": \"/system/user/user-list\",\n            \"meta\": {\n                \"title\": \"用户管理\",\n                \"icon\": \"user\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"c5f407478c4e4c9cbcdbee6389d2c909\",\n            \"name\": \"数据字典\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/dict/dict-list\",\n            \"sort\": 60,\n            \"icon\": \"dict\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/dict/dict-list\",\n            \"path\": \"/system/dict/dict-list\",\n            \"meta\": {\n                \"title\": \"数据字典\",\n                \"icon\": \"dict\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"10fc3bdde0c642aea2af34d281a49cf9\",\n            \"name\": \"测试数据\",\n            \"pid\": \"b1851d1b13594e71840103c11a37a669\",\n            \"isShow\": 1,\n            \"url\": \"/system/test/test-list\",\n            \"sort\": 100,\n            \"icon\": \"home\",\n            \"keepAlive\": 1,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/system/test/test-list\",\n            \"path\": \"/system/test/test-list\",\n            \"meta\": {\n                \"title\": \"测试数据\",\n                \"icon\": \"home\",\n                \"keepAlive\": true\n            }\n        }]\n    }, {\n        \"id\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n        \"name\": \"一些例子\",\n        \"pid\": \"0\",\n        \"isShow\": 1,\n        \"url\": \"/examples\",\n        \"sort\": 20,\n        \"icon\": \"examples\",\n        \"keepAlive\": 0,\n        \"code\": null,\n        \"componentname\": null,\n        \"component\": \"Layout\",\n        \"path\": \"/examples\",\n        \"meta\": {\n            \"title\": \"一些例子\",\n            \"icon\": \"examples\",\n            \"keepAlive\": false\n        },\n        \"redirect\": \"noRedirect\",\n        \"alwaysShow\": true,\n        \"children\": [{\n            \"id\": \"dc332875-831e-4937-86ff-0c7420915ce9\",\n            \"name\": \"三级联动\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/three-linkage\",\n            \"sort\": 10,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/three-linkage\",\n            \"path\": \"/examples/three-linkage\",\n            \"meta\": {\n                \"title\": \"三级联动\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"f09410d5-5043-4164-9f68-8d135de71b29\",\n            \"name\": \"上传文件\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/upload-file\",\n            \"sort\": 20,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/upload-file\",\n            \"path\": \"/examples/upload-file\",\n            \"meta\": {\n                \"title\": \"上传文件\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"74c852ea-be4b-4533-b146-cfbd776045d5\",\n            \"name\": \"富文本\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/ueditor-example\",\n            \"sort\": 30,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/ueditor-example\",\n            \"path\": \"/examples/ueditor-example\",\n            \"meta\": {\n                \"title\": \"富文本\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"91bdb7d742a64a8c8a8fdc6d3bb61581\",\n            \"name\": \"可编辑表格\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/editor-table\",\n            \"sort\": 40,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/editor-table\",\n            \"path\": \"/examples/editor-table\",\n            \"meta\": {\n                \"title\": \"可编辑表格\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"0ca23f378d794b23b935d6045bb54915\",\n            \"name\": \"页面设计\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/page-design\",\n            \"sort\": 50,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/page-design\",\n            \"path\": \"/examples/page-design\",\n            \"meta\": {\n                \"title\": \"页面设计\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }, {\n            \"id\": \"2664b76cb2904227bce5b0f7d1dd6e7b\",\n            \"name\": \"下拉框\",\n            \"pid\": \"641253af-8ea1-4b5d-8bc3-a7165ef60ff2\",\n            \"isShow\": 1,\n            \"url\": \"/examples/select-example\",\n            \"sort\": 60,\n            \"icon\": \"\",\n            \"keepAlive\": 0,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/examples/select-example\",\n            \"path\": \"/examples/select-example\",\n            \"meta\": {\n                \"title\": \"下拉框\",\n                \"icon\": \"\",\n                \"keepAlive\": false\n            }\n        }]\n    }, {\n        \"id\": \"d7f8d052d4864bd285c575c3cf2dce69\",\n        \"name\": \"低代码\",\n        \"pid\": \"0\",\n        \"isShow\": 1,\n        \"url\": \"/lowcode\",\n        \"sort\": 30,\n        \"icon\": null,\n        \"keepAlive\": 1,\n        \"code\": null,\n        \"componentname\": null,\n        \"component\": \"Layout\",\n        \"path\": \"/lowcode\",\n        \"meta\": {\n            \"title\": \"低代码\",\n            \"icon\": null,\n            \"keepAlive\": true\n        },\n        \"redirect\": \"noRedirect\",\n        \"alwaysShow\": true,\n        \"children\": [{\n            \"id\": \"9de78e0a6042469c891af82fbc21ba90\",\n            \"name\": \"组件管理\",\n            \"pid\": \"d7f8d052d4864bd285c575c3cf2dce69\",\n            \"isShow\": 1,\n            \"url\": \"/lowcode/component-list\",\n            \"sort\": 10,\n            \"icon\": null,\n            \"keepAlive\": 1,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/lowcode/component-list\",\n            \"path\": \"/lowcode/component-list\",\n            \"meta\": {\n                \"title\": \"组件管理\",\n                \"icon\": null,\n                \"keepAlive\": true\n            }\n        }, {\n            \"id\": \"c7445e2ac6144a15a76d723607fbfb9d\",\n            \"name\": \"接口管理\",\n            \"pid\": \"d7f8d052d4864bd285c575c3cf2dce69\",\n            \"isShow\": 1,\n            \"url\": \"/lowcode/magic-editor\",\n            \"sort\": 20,\n            \"icon\": null,\n            \"keepAlive\": 1,\n            \"code\": null,\n            \"componentname\": null,\n            \"component\": \"/lowcode/magic-editor\",\n            \"path\": \"/lowcode/magic-editor\",\n            \"meta\": {\n                \"title\": \"接口管理\",\n                \"icon\": null,\n                \"keepAlive\": true\n            }\n        }]\n    }],\n    \"timestamp\": 1646400974566,\n    \"executeTime\": 41\n}",
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
    "children" : [ ]
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
          "name" : "id",
          "value" : "b1851d1b13594e71840103c11a37a669",
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
          "name" : "name",
          "value" : "系统设置",
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
          "name" : "pid",
          "value" : "0",
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
          "name" : "isShow",
          "value" : "1",
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
          "name" : "url",
          "value" : "/system",
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
          "name" : "sort",
          "value" : "10",
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
          "name" : "icon",
          "value" : "settings",
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
          "name" : "keepAlive",
          "value" : "0",
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
          "name" : "code",
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
          "name" : "componentname",
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
          "name" : "component",
          "value" : "Layout",
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
          "name" : "path",
          "value" : "/system",
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
          "name" : "meta",
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
            "name" : "title",
            "value" : "系统设置",
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
            "name" : "icon",
            "value" : "settings",
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
            "name" : "keepAlive",
            "value" : "false",
            "description" : "",
            "required" : false,
            "dataType" : "Boolean",
            "type" : null,
            "defaultValue" : null,
            "validateType" : "",
            "error" : "",
            "expression" : "",
            "children" : [ ]
          } ]
        }, {
          "name" : "redirect",
          "value" : "noRedirect",
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
          "name" : "alwaysShow",
          "value" : "true",
          "description" : "",
          "required" : false,
          "dataType" : "Boolean",
          "type" : null,
          "defaultValue" : null,
          "validateType" : "",
          "error" : "",
          "expression" : "",
          "children" : [ ]
        }, {
          "name" : "children",
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
              "name" : "id",
              "value" : "39be13ef6f0745568c80bf35202ddb2b",
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
              "name" : "name",
              "value" : "菜单管理",
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
              "name" : "pid",
              "value" : "b1851d1b13594e71840103c11a37a669",
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
              "name" : "isShow",
              "value" : "1",
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
              "name" : "url",
              "value" : "/system/menu/menu-list",
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
              "name" : "sort",
              "value" : "10",
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
              "name" : "icon",
              "value" : "menu",
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
              "name" : "keepAlive",
              "value" : "1",
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
              "name" : "code",
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
              "name" : "componentname",
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
              "name" : "component",
              "value" : "/system/menu/menu-list",
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
              "name" : "path",
              "value" : "/system/menu/menu-list",
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
              "name" : "meta",
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
                "name" : "title",
                "value" : "菜单管理",
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
                "name" : "icon",
                "value" : "menu",
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
                "name" : "keepAlive",
                "value" : "true",
                "description" : "",
                "required" : false,
                "dataType" : "Boolean",
                "type" : null,
                "defaultValue" : null,
                "validateType" : "",
                "error" : "",
                "expression" : "",
                "children" : [ ]
              } ]
            } ]
          } ]
        } ]
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1646400974566",
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
      "value" : "41",
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
  }
}
================================
import 'cn.dev33.satoken.stp.StpUtil';

var userId = StpUtil.getLoginId()

var menus = db.select("""
    select
        sm.id,
        sm.name title,
        sm.pid,
        sm.is_show,
        sm.url,
        sm.sort,
        sm.icon,
        sm.keep_alive,
        sm.component_name
    from sys_menu sm where 1=1
    ?{userId != '1',
        and sm.id in (
            select menu_id from sys_role_menu where role_id in (
                select role_id from sys_user_role where user_id = #{userId}
            )
        )
    } and sm.is_del = '0' and sm.is_show = 1 order by sm.sort
""")

for(menu in menus){
    menu.component = (menu.url || "Layout");
    menu.path = (menu.component == 'Layout' ? "/" : menu.component);
    menu.meta = {}
    menu.meta.title = menu.title
    menu.meta.icon = menu.icon
    menu.meta.keepAlive = (menu.keepAlive == '1' ? true : false)
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
        if(node.component != 'Layout'){
            node = {
                isShow: 1,
                component: 'Layout',
                redirect: node.path,
                children: [node]
            }
        }
        treeNodes.push(node)
    }
})

return treeNodes
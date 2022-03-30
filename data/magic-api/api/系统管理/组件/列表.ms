{
  "properties" : { },
  "id" : "56ed96789b1e4b649265da83a7b3b8b4",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "列表",
  "createTime" : null,
  "updateTime" : 1648611595092,
  "lock" : "0",
  "createBy" : null,
  "updateBy" : null,
  "path" : "/list",
  "method" : "POST",
  "parameters" : [ ],
  "options" : [ ],
  "requestBody" : "",
  "headers" : [ ],
  "paths" : [ ],
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": [{\n        \"name\": \"data-test-list\",\n        \"code\": \"\\n    <template>\\n      <mb-list ref=\\\"magicList\\\" v-bind=\\\"listOptions\\\" />\\n      <mb-dialog ref=\\\"formDialog\\\" @confirm-click=\\\"magicForm.save($event)\\\" width=\\\"50%\\\">\\n        <template #content>\\n          <mb-form ref=\\\"magicForm\\\" @reload=\\\"magicList.reload\\\" v-bind=\\\"formOptions\\\" />\\n        </template>\\n      </mb-dialog>\\n    </template>\\n    <script setup>\\n    import { ref, reactive, getCurrentInstance } from 'vue'\\n    const { proxy } = getCurrentInstance()\\n    const formDialog = ref()\\n    const magicList = ref()\\n    const magicForm = ref()\\n    const listOptions = reactive({\\n        tools: [{\\n            type: 'add',\\n            permission: ':data/test:save',\\n            click: () => {\\n                formOptions.detail.formData = null\\n                formDialog.value.show()\\n            }\\n        }],\\n        table: {\\n            url: '/data/test/list',\\n            where: {\\n                name: {\\n                    label: '名字'\\n                },\\n                sex: {\\n                    label: '性别'\\n                },\\n                headPortrait: {\\n                    label: '头像'\\n                },\\n                remarks: {\\n                    label: '备注'\\n                }\\n            },\\n            cols: [\\n                {\\n                \\n                    field: 'name',\\n                    label: '名字'\\n                },\\n                {\\n                    dictType: 'sex',\\n                    field: 'sex',\\n                    label: '性别'\\n                },\\n                {\\n                \\n                    field: 'headPortrait',\\n                    label: '头像'\\n                },\\n                {\\n                \\n                    field: 'remarks',\\n                    label: '备注'\\n                },{\\n                    label: '操作',\\n                    type: 'btns',\\n                    width: 140,\\n                    fixed: 'right',\\n                    btns: [\\n                        {\\n                            permission: ':data/test:save',\\n                            label: '修改',\\n                            type: 'text',\\n                            icon: 'ElEdit',\\n                            click: (row) => {\\n                                magicForm.value.getDetail(row.id)\\n                                formDialog.value.show()\\n                            }\\n                        }, {\\n                            permission: ':data/test:delete',\\n                            label: '删除',\\n                            type: 'text',\\n                            icon: 'ElDelete',\\n                            click: (row) => {\\n                                proxy.$common.handleDelete({\\n                                    url: '/data/test/delete',\\n                                    id: row.id,\\n                                    done: () => magicList.value.reload()\\n                                })\\n                            }\\n                        }\\n                    ]\\n                }\\n            ]\\n        }\\n    })\\n    \\n    const formOptions = reactive({\\n        detail: {\\n            request: {\\n              url: '/data/test/get'\\n            }\\n        },\\n        form: {\\n            request: {\\n                url: \\\"/data/test/save\\\",\\n                method: \\\"post\\\"\\n            },\\n            rows: [{\\n                gutter: 24,\\n                cols: [{\\n                    span: 12,\\n                    name: 'name',\\n                    label: '名字',\\n                    component: 'input'\\n                },{\\n                    span: 12,\\n                    name: 'sex',\\n                    label: '性别',\\n                    component: 'radio-group'\\n                },{\\n                    span: 12,\\n                    name: 'headPortrait',\\n                    label: '头像',\\n                    component: 'upload-image'\\n                },{\\n                    span: 12,\\n                    name: 'remarks',\\n                    label: '备注',\\n                    component: 'input',\\n                    props: {\\n                        type: 'textarea'\\n                    }\\n      \\n                }]\\n            }]\\n        }\\n    })\\n    \"\n    }],\n    \"timestamp\": 1648608988019,\n    \"executeTime\": 24\n}",
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
      "dataType" : "Object",
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
          "name" : "name",
          "value" : "data-test-list",
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
          "name" : "code",
          "value" : "\\n    <template>\\n      <mb-list ref=\\\"magicList\\\" v-bind=\\\"listOptions\\\" />\\n      <mb-dialog ref=\\\"formDialog\\\" @confirm-click=\\\"magicForm.save($event)\\\" width=\\\"50%\\\">\\n        <template #content>\\n          <mb-form ref=\\\"magicForm\\\" @reload=\\\"magicList.reload\\\" v-bind=\\\"formOptions\\\" />\\n        </template>\\n      </mb-dialog>\\n    </template>\\n    <script setup>\\n    import { ref, reactive, getCurrentInstance } from 'vue'\\n    const { proxy } = getCurrentInstance()\\n    const formDialog = ref()\\n    const magicList = ref()\\n    const magicForm = ref()\\n    const listOptions = reactive({\\n        tools: [{\\n            type: 'add',\\n            permission: ':data/test:save',\\n            click: () => {\\n                formOptions.detail.formData = null\\n                formDialog.value.show()\\n            }\\n        }],\\n        table: {\\n            url: '/data/test/list',\\n            where: {\\n                name: {\\n                    label: '名字'\\n                },\\n                sex: {\\n                    label: '性别'\\n                },\\n                headPortrait: {\\n                    label: '头像'\\n                },\\n                remarks: {\\n                    label: '备注'\\n                }\\n            },\\n            cols: [\\n                {\\n                \\n                    field: 'name',\\n                    label: '名字'\\n                },\\n                {\\n                    dictType: 'sex',\\n                    field: 'sex',\\n                    label: '性别'\\n                },\\n                {\\n                \\n                    field: 'headPortrait',\\n                    label: '头像'\\n                },\\n                {\\n                \\n                    field: 'remarks',\\n                    label: '备注'\\n                },{\\n                    label: '操作',\\n                    type: 'btns',\\n                    width: 140,\\n                    fixed: 'right',\\n                    btns: [\\n                        {\\n                            permission: ':data/test:save',\\n                            label: '修改',\\n                            type: 'text',\\n                            icon: 'ElEdit',\\n                            click: (row) => {\\n                                magicForm.value.getDetail(row.id)\\n                                formDialog.value.show()\\n                            }\\n                        }, {\\n                            permission: ':data/test:delete',\\n                            label: '删除',\\n                            type: 'text',\\n                            icon: 'ElDelete',\\n                            click: (row) => {\\n                                proxy.$common.handleDelete({\\n                                    url: '/data/test/delete',\\n                                    id: row.id,\\n                                    done: () => magicList.value.reload()\\n                                })\\n                            }\\n                        }\\n                    ]\\n                }\\n            ]\\n        }\\n    })\\n    \\n    const formOptions = reactive({\\n        detail: {\\n            request: {\\n              url: '/data/test/get'\\n            }\\n        },\\n        form: {\\n            request: {\\n                url: \\\"/data/test/save\\\",\\n                method: \\\"post\\\"\\n            },\\n            rows: [{\\n                gutter: 24,\\n                cols: [{\\n                    span: 12,\\n                    name: 'name',\\n                    label: '名字',\\n                    component: 'input'\\n                },{\\n                    span: 12,\\n                    name: 'sex',\\n                    label: '性别',\\n                    component: 'radio-group'\\n                },{\\n                    span: 12,\\n                    name: 'headPortrait',\\n                    label: '头像',\\n                    component: 'upload-image'\\n                },{\\n                    span: 12,\\n                    name: 'remarks',\\n                    label: '备注',\\n                    component: 'input',\\n                    props: {\\n                        type: 'textarea'\\n                    }\\n      \\n                }]\\n            }]\\n        }\\n    })\\n",
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
      } ]
    }, {
      "name" : "timestamp",
      "value" : "1648608988019",
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
      "value" : "24",
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
import org.ssssssss.magicapi.utils.PathUtils
import org.ssssssss.magicapi.core.service.MagicResourceService
return MagicResourceService.files('component').map(it => { 
    name: PathUtils.replaceSlash(String.format("%s/%s", MagicResourceService.getGroupPath(it.groupId), it.path)).replace(/^\//,'').replace(/\/\//, '/').replace('/', '-'),
    code: it.script
})
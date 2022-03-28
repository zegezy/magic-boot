{
  "properties" : { },
  "id" : "56ed96789b1e4b649265da83a7b3b8b4",
  "script" : null,
  "groupId" : "6f106ebdee21489db34b956f7770ff03",
  "name" : "列表",
  "createTime" : null,
  "updateTime" : 1648017562433,
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
  "responseBody" : "{\n    \"code\": 200,\n    \"message\": \"success\",\n    \"data\": [{\n        \"name\": \"sys-dict-list\",\n        \"code\": \"<template>\\n  <div class=\\\"app-container\\\">\\n\\n    <mb-search :where=\\\"tableOptions.where\\\" @search=\\\"reloadTable\\\" />\\n\\n    <el-row class=\\\"toolbar-container\\\">\\n      <el-button v-permission=\\\"'dict:save'\\\" class=\\\"filter-item\\\" type=\\\"primary\\\" icon=\\\"ElPlus\\\" @click=\\\"handleCreate\\\">\\n        添加1\\n      </el-button>\\n    </el-row>\\n\\n    <mb-table ref=\\\"table\\\" v-bind=\\\"tableOptions\\\" />\\n\\n    <mb-dialog ref=\\\"dictDialog\\\" :title=\\\"dialogTitle\\\" width=\\\"640px\\\" @confirm-click=\\\"save($event)\\\">\\n      <template #content>\\n        <el-form ref=\\\"dataForm\\\" :inline=\\\"true\\\" :rules=\\\"rules\\\" :model=\\\"temp\\\" label-position=\\\"right\\\" label-width=\\\"80px\\\">\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"字典类型\\\" prop=\\\"dictType\\\">\\n                <mb-select v-model=\\\"temp.dictType\\\" type=\\\"dict_type\\\" width=\\\"185px\\\" />\\n              </el-form-item>\\n            </el-col>\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"类型\\\" prop=\\\"type\\\">\\n                <el-input v-model=\\\"temp.type\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"排序\\\" prop=\\\"sort\\\">\\n                <el-input v-model=\\\"temp.sort\\\" />\\n              </el-form-item>\\n            </el-col>\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"描述\\\" prop=\\\"descRibe\\\">\\n                <el-input v-model=\\\"temp.descRibe\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"备注\\\" prop=\\\"remarks\\\">\\n                <el-input v-model=\\\"temp.remarks\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n        </el-form>\\n      </template>\\n    </mb-dialog>\\n\\n  </div>\\n</template>\\n\\n<script setup>\\n\\nimport { ref, reactive, getCurrentInstance, nextTick } from 'vue'\\n\\nconst { proxy } = getCurrentInstance()\\n\\nconst tableOptions = reactive({\\n  url: 'dict/list',\\n  page: true,\\n  where: {\\n    type: {\\n      type: 'input',\\n      label: '类型',\\n      value: ''\\n    },\\n    dictType: {\\n      type: 'select',\\n      label: '字典类型',\\n      value: '',\\n      properties: {\\n        'all-option': true,\\n        type: 'dict_type'\\n      }\\n    }\\n  },\\n  cols: [\\n    {\\n      field: 'type',\\n      label: '类型'\\n    },\\n    {\\n      field: 'descRibe',\\n      label: '描述'\\n    },\\n    {\\n      field: 'dictType',\\n      label: '字典类型',\\n      width: 200,\\n      dictType: 'dict_type'\\n    },\\n    {\\n      field: 'remarks',\\n      label: '备注',\\n      width: 200\\n    },\\n    {\\n      field: 'sort',\\n      label: '排序',\\n      width: 100\\n    },\\n    {\\n      label: '操作',\\n      type: 'btns',\\n      width: 220,\\n      fixed: 'right',\\n      btns: [\\n        {\\n          permission: 'dict:save',\\n          label: '修改',\\n          type: 'text',\\n          icon: 'ElEdit',\\n          click: (row) => {\\n            handleUpdate(row)\\n          }\\n        },\\n        {\\n          permission: 'dict:delete',\\n          label: '删除',\\n          type: 'text',\\n          icon: 'ElDelete',\\n          click: (row) => {\\n            proxy.$common.handleDelete({\\n              url: 'dict/delete',\\n              id: row.id,\\n              done: () => {\\n                reloadTable()\\n                proxy.$common.getDictData()\\n              }\\n            })\\n          }\\n        }\\n      ]\\n    }\\n  ]\\n})\\n\\nconst dictId = ref('')\\nconst temp = ref(getTemp())\\nconst dialogTitle = ref('')\\nconst rules = reactive({\\n  dictType: [{ required: true, message: '请输入标签', trigger: 'change' }],\\n  type: [{ required: true, message: '请输入类型', trigger: 'change' }],\\n  sort: [{ required: true, message: '请输入排序', trigger: 'change' }],\\n  descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]\\n})\\nconst table = ref()\\nconst dictDialog = ref()\\nconst dataForm = ref()\\n\\nfunction getTemp() {\\n  return {\\n    id: '',\\n    dictType: '',\\n    type: '',\\n    sort: 0,\\n    descRibe: '',\\n    remarks: ''\\n  }\\n}\\n\\nfunction reloadTable() {\\n  table.value.reload()\\n}\\n\\nfunction getSort() {\\n  proxy.$get('/system/dict/sort').then(res => {\\n    temp.value.sort = res.data\\n  })\\n}\\n\\nfunction handleCreate() {\\n  temp.value = getTemp()\\n  getSort()\\n  dialogTitle.value = '添加'\\n  dictDialog.value.show()\\n  nextTick(() => {\\n    dataForm.value.clearValidate()\\n  })\\n}\\n\\nfunction save(d) {\\n  dataForm.value.validate((valid) => {\\n    if (valid) {\\n      d.loading()\\n      proxy.$post('/system/dict/save', temp.value).then((response) => {\\n        d.hideLoading()\\n        temp.value.id = response.data\\n        dictDialog.value.hide()\\n        proxy.$notify({\\n          title: '成功',\\n          message: dialogTitle.value + '成功',\\n          type: 'success',\\n          duration: 2000\\n        })\\n        reloadTable()\\n        proxy.$common.getDictData()\\n      }).catch(() => d.hideLoading())\\n    }\\n  })\\n}\\n\\nfunction handleUpdate(row) {\\n  proxy.$common.objAssign(temp.value, row)\\n  dialogTitle.value = '修改'\\n  dictDialog.value.show()\\n  nextTick(() => {\\n    dataForm.value.clearValidate()\\n  })\\n}\\n\\n</script>\\n\"\n    }],\n    \"timestamp\": 1648017503577,\n    \"executeTime\": 12\n}",
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
          "value" : "sys-dict-list",
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
          "value" : "<template>\\n  <div class=\\\"app-container\\\">\\n\\n    <mb-search :where=\\\"tableOptions.where\\\" @search=\\\"reloadTable\\\" />\\n\\n    <el-row class=\\\"toolbar-container\\\">\\n      <el-button v-permission=\\\"'dict:save'\\\" class=\\\"filter-item\\\" type=\\\"primary\\\" icon=\\\"ElPlus\\\" @click=\\\"handleCreate\\\">\\n        添加1\\n      </el-button>\\n    </el-row>\\n\\n    <mb-table ref=\\\"table\\\" v-bind=\\\"tableOptions\\\" />\\n\\n    <mb-dialog ref=\\\"dictDialog\\\" :title=\\\"dialogTitle\\\" width=\\\"640px\\\" @confirm-click=\\\"save($event)\\\">\\n      <template #content>\\n        <el-form ref=\\\"dataForm\\\" :inline=\\\"true\\\" :rules=\\\"rules\\\" :model=\\\"temp\\\" label-position=\\\"right\\\" label-width=\\\"80px\\\">\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"字典类型\\\" prop=\\\"dictType\\\">\\n                <mb-select v-model=\\\"temp.dictType\\\" type=\\\"dict_type\\\" width=\\\"185px\\\" />\\n              </el-form-item>\\n            </el-col>\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"类型\\\" prop=\\\"type\\\">\\n                <el-input v-model=\\\"temp.type\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"排序\\\" prop=\\\"sort\\\">\\n                <el-input v-model=\\\"temp.sort\\\" />\\n              </el-form-item>\\n            </el-col>\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"描述\\\" prop=\\\"descRibe\\\">\\n                <el-input v-model=\\\"temp.descRibe\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n          <el-row :gutter=\\\"24\\\">\\n            <el-col :span=\\\"12\\\">\\n              <el-form-item label=\\\"备注\\\" prop=\\\"remarks\\\">\\n                <el-input v-model=\\\"temp.remarks\\\" />\\n              </el-form-item>\\n            </el-col>\\n          </el-row>\\n        </el-form>\\n      </template>\\n    </mb-dialog>\\n\\n  </div>\\n</template>\\n\\n<script setup>\\n\\nimport { ref, reactive, getCurrentInstance, nextTick } from 'vue'\\n\\nconst { proxy } = getCurrentInstance()\\n\\nconst tableOptions = reactive({\\n  url: 'dict/list',\\n  page: true,\\n  where: {\\n    type: {\\n      type: 'input',\\n      label: '类型',\\n      value: ''\\n    },\\n    dictType: {\\n      type: 'select',\\n      label: '字典类型',\\n      value: '',\\n      properties: {\\n        'all-option': true,\\n        type: 'dict_type'\\n      }\\n    }\\n  },\\n  cols: [\\n    {\\n      field: 'type',\\n      label: '类型'\\n    },\\n    {\\n      field: 'descRibe',\\n      label: '描述'\\n    },\\n    {\\n      field: 'dictType',\\n      label: '字典类型',\\n      width: 200,\\n      dictType: 'dict_type'\\n    },\\n    {\\n      field: 'remarks',\\n      label: '备注',\\n      width: 200\\n    },\\n    {\\n      field: 'sort',\\n      label: '排序',\\n      width: 100\\n    },\\n    {\\n      label: '操作',\\n      type: 'btns',\\n      width: 220,\\n      fixed: 'right',\\n      btns: [\\n        {\\n          permission: 'dict:save',\\n          label: '修改',\\n          type: 'text',\\n          icon: 'ElEdit',\\n          click: (row) => {\\n            handleUpdate(row)\\n          }\\n        },\\n        {\\n          permission: 'dict:delete',\\n          label: '删除',\\n          type: 'text',\\n          icon: 'ElDelete',\\n          click: (row) => {\\n            proxy.$common.handleDelete({\\n              url: 'dict/delete',\\n              id: row.id,\\n              done: () => {\\n                reloadTable()\\n                proxy.$common.getDictData()\\n              }\\n            })\\n          }\\n        }\\n      ]\\n    }\\n  ]\\n})\\n\\nconst dictId = ref('')\\nconst temp = ref(getTemp())\\nconst dialogTitle = ref('')\\nconst rules = reactive({\\n  dictType: [{ required: true, message: '请输入标签', trigger: 'change' }],\\n  type: [{ required: true, message: '请输入类型', trigger: 'change' }],\\n  sort: [{ required: true, message: '请输入排序', trigger: 'change' }],\\n  descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]\\n})\\nconst table = ref()\\nconst dictDialog = ref()\\nconst dataForm = ref()\\n\\nfunction getTemp() {\\n  return {\\n    id: '',\\n    dictType: '',\\n    type: '',\\n    sort: 0,\\n    descRibe: '',\\n    remarks: ''\\n  }\\n}\\n\\nfunction reloadTable() {\\n  table.value.reload()\\n}\\n\\nfunction getSort() {\\n  proxy.$get('/system/dict/sort').then(res => {\\n    temp.value.sort = res.data\\n  })\\n}\\n\\nfunction handleCreate() {\\n  temp.value = getTemp()\\n  getSort()\\n  dialogTitle.value = '添加'\\n  dictDialog.value.show()\\n  nextTick(() => {\\n    dataForm.value.clearValidate()\\n  })\\n}\\n\\nfunction save(d) {\\n  dataForm.value.validate((valid) => {\\n    if (valid) {\\n      d.loading()\\n      proxy.$post('/system/dict/save', temp.value).then((response) => {\\n        d.hideLoading()\\n        temp.value.id = response.data\\n        dictDialog.value.hide()\\n        proxy.$notify({\\n          title: '成功',\\n          message: dialogTitle.value + '成功',\\n          type: 'success',\\n          duration: 2000\\n        })\\n        reloadTable()\\n        proxy.$common.getDictData()\\n      }).catch(() => d.hideLoading())\\n    }\\n  })\\n}\\n\\nfunction handleUpdate(row) {\\n  proxy.$common.objAssign(temp.value, row)\\n  dialogTitle.value = '修改'\\n  dictDialog.value.show()\\n  nextTick(() => {\\n    dataForm.value.clearValidate()\\n  })\\n}\\n\\n</script>\\n",
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
      "value" : "1648017503577",
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
      "value" : "12",
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
    name: PathUtils.replaceSlash(String.format("%s-%s", MagicResourceService.getGroupPath(it.groupId), it.path)).replace('/', '-'),
    code: it.script
})

{
  "properties" : { },
  "id" : "995e2ee59d574429b8e3da3513c05a43",
  "script" : null,
  "groupId" : "6bee7576eea04963a573b21bb657784d",
  "name" : "列表",
  "createTime" : 1648017481335,
  "updateTime" : 1648026074180,
  "lock" : null,
  "createBy" : null,
  "updateBy" : null,
  "path" : "list",
  "description" : null
}
================================
<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'dict:save'" class="filter-item" type="primary" icon="ElPlus" @click="handleCreate">
        添加13asdf
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="dictDialog" :title="dialogTitle" width="640px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="字典类型" prop="dictType">
                <mb-select v-model="temp.dictType" type="dict_type" width="185px" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="类型" prop="type">
                <el-input v-model="temp.type" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="排序" prop="sort">
                <el-input v-model="temp.sort" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="描述" prop="descRibe">
                <el-input v-model="temp.descRibe" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="备注" prop="remarks">
                <el-input v-model="temp.remarks" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>

import { ref, reactive, getCurrentInstance, nextTick } from 'vue'

const { proxy } = getCurrentInstance()

const tableOptions = reactive({
  url: 'dict/list',
  page: true,
  where: {
    type: {
      type: 'input',
      label: '类型',
      value: ''
    },
    dictType: {
      type: 'select',
      label: '字典类型',
      value: '',
      properties: {
        'all-option': true,
        type: 'dict_type'
      }
    }
  },
  cols: [
    {
      field: 'type',
      label: '类型'
    },
    {
      field: 'descRibe',
      label: '描述'
    },
    {
      field: 'dictType',
      label: '字典类型',
      width: 200,
      dictType: 'dict_type'
    },
    {
      field: 'remarks',
      label: '备注',
      width: 200
    },
    {
      field: 'sort',
      label: '排序',
      width: 100
    },
    {
      label: '操作',
      type: 'btns',
      width: 220,
      fixed: 'right',
      btns: [
        {
          permission: 'dict:save',
          label: '修改',
          type: 'text',
          icon: 'ElEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'dict:delete',
          label: '删除',
          type: 'text',
          icon: 'ElDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: 'dict/delete',
              id: row.id,
              done: () => {
                reloadTable()
                proxy.$common.getDictData()
              }
            })
          }
        }
      ]
    }
  ]
})

const dictId = ref('')
const temp = ref(getTemp())
const dialogTitle = ref('')
const rules = reactive({
  dictType: [{ required: true, message: '请输入标签', trigger: 'change' }],
  type: [{ required: true, message: '请输入类型', trigger: 'change' }],
  sort: [{ required: true, message: '请输入排序', trigger: 'change' }],
  descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]
})
const table = ref()
const dictDialog = ref()
const dataForm = ref()

function getTemp() {
  return {
    id: '',
    dictType: '',
    type: '',
    sort: 0,
    descRibe: '',
    remarks: ''
  }
}

function reloadTable() {
  table.value.reloadList()
}

function getSort() {
  proxy.$get('dict/sort').then(res => {
    temp.value.sort = res.data
  })
}

function handleCreate() {
  temp.value = getTemp()
  getSort()
  dialogTitle.value = '添加'
  dictDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      proxy.$post('dict/save', temp.value).then((response) => {
        d.hideLoading()
        temp.value.id = response.data
        dictDialog.value.hide()
        proxy.$notify({
          title: '成功',
          message: dialogTitle.value + '成功',
          type: 'success',
          duration: 2000
        })
        reloadTable()
        proxy.$common.getDictData()
      }).catch(() => d.hideLoading())
    }
  })
}

function handleUpdate(row) {
  proxy.$common.objAssign(temp.value, row)
  dialogTitle.value = '修改'
  dictDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

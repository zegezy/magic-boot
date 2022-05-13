<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'dict:save'" class="filter-item" type="primary" icon="ElIconPlus" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="dictDialog" :title="dialogTitle" width="640px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="字典类型" prop="dictType">
                <mb-select v-model="temp.dictType" type="dict_type" />
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
              <el-form-item label="描述" prop="descRibe">
                <el-input v-model="temp.descRibe" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="备注" prop="remarks">
                <el-input v-model="temp.remarks" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

    <mb-dialog ref="dictItemsDialog" title="字典项" width="1400px" :show-footer="false">
      <template #content>
        <dict-items :key="Math.random()" v-model:dict-id="dictId" />
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>
import DictItems from './dict-items'

import { ref, reactive, getCurrentInstance, nextTick } from 'vue'

const { proxy } = getCurrentInstance()

const tableOptions = reactive({
  url: '/system/dict/list',
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
      props: {
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
      field: 'createDate',
      label: '创建时间'
    },
    {
      field: 'remarks',
      label: '备注',
      width: 200
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
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'dict:delete',
          label: '删除',
          type: 'text',
          icon: 'ElIconDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/dict/delete',
              id: row.id,
              done: () => {
                reloadTable()
                proxy.$common.getDictData()
              }
            })
          }
        },
        {
          permission: 'dict:items:view',
          label: '字典项',
          type: 'text',
          icon: 'ElIconList',
          click: (row) => {
            dictItemsDialog.value.show()
            dictId.value = row.id
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
  descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]
})
const table = ref()
const dictDialog = ref()
const dataForm = ref()
const dictItemsDialog = ref()

function getTemp() {
  return {
    id: '',
    dictType: '',
    type: '',
    descRibe: '',
    remarks: ''
  }
}

function reloadTable() {
  table.value.reload()
}

function handleCreate() {
  temp.value = getTemp()
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
      proxy.$post('/system/dict/save', temp.value).then((response) => {
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

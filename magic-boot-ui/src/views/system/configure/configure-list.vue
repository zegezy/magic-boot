<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'configure:save'" class="filter-item" type="primary" icon="ElIconPlus" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="roleFormDialog" :title="dialogTitle" width="900px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="键值" prop="configureKey">
                <mb-input v-model="temp.configureKey" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="数据值" prop="configureValue">
                <el-input v-model="temp.configureValue" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="名称" prop="configureName">
                <mb-input v-model="temp.configureName" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="配置类型" prop="configureType">
                <mb-select v-model="temp.configureType" type="dict_type"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="24">
              <el-form-item label="条件筛选" prop="configureCondition">
                <el-input
                    type="textarea"
                    :rows="4"
                    placeholder="请输入条件筛选"
                    v-model="temp.configureCondition">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="24">
              <el-form-item label="配置说明" prop="configureDescRibe">
                <el-input
                    type="textarea"
                    :rows="4"
                    placeholder="请输入配置说明"
                    v-model="temp.configureDescRibe">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="24">
              <el-form-item label="备注" prop="remarks">
                <el-input
                    type="textarea"
                    :rows="4"
                    placeholder="请输入备注"
                    v-model="temp.remarks">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>
  </div>
</template>

<script setup>

import { ref, reactive, nextTick, getCurrentInstance } from 'vue'

const { proxy } = getCurrentInstance()
const dialogTitle = ref('')
const roleFormDialog = ref()
const tableOptions = reactive({
  url: '/system/configure/list',
  page: true,
  where: {
    configureCondition: {
      type: 'input',
      label: '条件',
      value: ''
    },
    configureKey: {
      type: 'input',
      label: '键值',
      value: ''
    }
  },
  cols: [
    {
      field: 'configureKey',
      label: '配置键值',
      width: 200
    },
    {
      field: 'configureValue',
      label: '配置数据'
    },
    {
      field: 'configureName',
      label: '配置名称'
    },
    {
      field: 'configureType',
      label: '配置类型',
      dictType: 'dict_type'
    },
    {
      field: 'configureCondition',
      label: '查询条件'
    },
    {
      field: 'configureDescRibe',
      label: '配置说明',
      width: 200
    },
    {
      field: 'remarks',
      label: '备注',
      width: 200
    },
    {
      field: 'createDate',
      label: '创建时间',
      width: 200
    },
    {
      label: '操作',
      type: 'btns',
      width: 220,
      fixed: 'right',
      btns: [
        {
          permission: 'configure:save',
          label: '修改',
          type: 'text',
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'configure:delete',
          label: '删除',
          type: 'text',
          icon: 'ElIconDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/configure/delete',
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
const temp = ref(getTemp())
const dialogFormVisible = ref(false)
const dialogStatus = ref('')
const textMap = reactive({
  update: '修改',
  create: '添加'
})
const rules = reactive({
  configureName: [{ required: true, message: '请输入配置名称', trigger: 'change' }],
  configureKey: [{ required: true, message: '请输入配置键值', trigger: 'change' }],
  configureValue: [{ required: true, message: '请输入配置数据', trigger: 'change' }],
  configureType: [{ required: true, message: '请选择类型', trigger: 'change' }]
})
const table = ref()
const dataForm = ref()

function getTemp() {
  return {
    id: '',
    configureCondition:'',
    configureName:'',
    configureKey:'',
    configureValue:'',
    configureType:'',
    configureDescRibe:'',
    remarks:''
  }
}

function reloadTable() {
  table.value.reload()
}

function handleCreate() {
  temp.value = getTemp()
  dialogTitle.value = '添加'
  roleFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save() {
  dataForm.value.validate((valid) => {
    if (valid) {
      proxy.$post('/system/configure/save', temp.value).then((response) => {
        roleFormDialog.value.hide()
        proxy.$notify({
          title: '成功',
          message: (dialogStatus.value === 'create' ? '创建' : '修改') + '成功',
          type: 'success',
          duration: 2000
        })
        reloadTable()
      })
    }
  })
}

function handleUpdate(row) {
  proxy.$common.objAssign(temp.value, row)
  dialogTitle.value = '添加'
  roleFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

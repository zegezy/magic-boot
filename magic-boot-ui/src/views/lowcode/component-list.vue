<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'component:save'" class="filter-item" type="primary" icon="ElPlus" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="formDialog" :fullscreen="true" :title="dialogTitle" width="900px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-form-item label="组件名称" prop="name">
            <el-input v-model="temp.name" />
          </el-form-item>
          <el-form-item label="组件描述" prop="descRibe">
            <el-input v-model="temp.descRibe" />
          </el-form-item>
          <el-form-item label="组件代码" prop="code">
            <el-input v-model="temp.code" :rows="30" type="textarea" />
          </el-form-item>
        </el-form>
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>
import { ref, reactive,getCurrentInstance, nextTick } from 'vue'

const { proxy } = getCurrentInstance()

const table = ref()
const formDialog = ref()
const dataForm = ref()
const tableOptions = reactive({
        url: 'component/list',
        where: {
          name: {
            type: 'input',
            label: '组件名称',
            value: ''
          },
          descRibe: {
            type: 'input',
            label: '组件描述',
            value: ''
          }
        },
        cols: [
          {
            field: 'name',
            label: '组件名称'
          },
          {
            field: 'descRibe',
            label: '组件描述'
          },
          {
            label: '操作',
            type: 'btns',
            width: 270,
            fixed: 'right',
            btns: [
              {
                permission: 'component:save',
                label: '修改',
                type: 'text',
                icon: 'ElEdit',
                click: (row) => {
                  handleUpdate(row)
                }
              },
              {
                permission: 'component:delete',
                label: '删除',
                type: 'text',
                icon: 'ElDelete',
                click: (row) => {
                  proxy.$common.handleDelete({
                    url: 'component/delete',
                    id: row.id,
                    done: () => reloadTable()
                  })
                }
              }
            ]
          }
        ]
      })
const dialogTitle = ref('')
const temp = ref(getTemp())
const rules = reactive({
  name: [{ required: true, message: '请输入组件名称', trigger: 'change' }],
  descRibe: [{ required: true, message: '请输入组件描述', trigger: 'change' }],
  code: [{ required: true, message: '请输入组件代码', trigger: 'change' }]
})
const downloadLoading = ref(false)

function reloadTable() {
  table.value.reloadList()
}

function getTemp(){
  return {
    id: '',
    name: '',
    code: '',
    descRibe: ''
  }
}

function resetTemp() {
  temp.value = getTemp()
}

function handleCreate() {
  resetTemp()
  dialogTitle.value = '添加'
  formDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      proxy.$post('component/save', temp.value).then(() => {
        d.hideLoading()
        reloadTable()
        formDialog.value.hide()
        proxy.$notify({
          title: '成功',
          message: dialogTitle.value + '成功',
          type: 'success',
          duration: 2000
        })
      }).catch(() => d.hideLoading())
    }
  })
}

function handleUpdate(row) {
  for (var t in temp.value) {
    temp.value[t] = row[t]
  }
  dialogTitle.value = '修改'
  formDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

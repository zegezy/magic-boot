<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item>
          <el-button class="filter-item" type="primary" icon="ElIconEdit" @click="handleCreate">
            添加
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <mb-table ref="table" v-bind="tableOptions" />

    <el-dialog :title="textMap[dialogStatus]" v-model="dialogFormVisible" :close-on-click-modal="false" width="700px">
      <el-form ref="dataForm" :inline="true" :model="temp" label-position="right" label-width="100px" style="margin-left: 20px">
        <el-form-item label="name" prop="name">
          <el-input v-model="temp.name" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible = false">
            关闭
          </el-button>
          <el-button type="primary" @click="save()">
            确认
          </el-button>
        </div>
      </template>
    </el-dialog>

  </div>
</template>

<script setup>

import { ref, reactive, nextTick, getCurrentInstance } from 'vue'

const { proxy } = getCurrentInstance()

const tableOptions = reactive({
  url: '/system/test/list',
  page: true,
  cols: [
    {
      field: 'name',
      label: 'name'
    },
  ]
})
const temp = ref(getTemp())
const dialogFormVisible = ref(false)
const dialogStatus = ref('')
const textMap = reactive({
  update: '修改',
  create: '添加'
})
const table = ref()
const dataForm = ref()

function getTemp() {
  return {
    name: ''
  }
}

function reloadTable() {
  table.value.reload()
}

function handleCreate() {
  temp.value = getTemp()
  dialogStatus.value = 'create'
  dialogFormVisible.value = true
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save() {
  dataForm.value.validate((valid) => {
    if (valid) {
      proxy.$post('/system/test/save', temp.value).then((response) => {
        dialogFormVisible.value = false
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

</script>

<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" not-reset="dictId" />

    <el-row class="toolbar-container">
      <el-button v-permission="'dict:items:save'" class="filter-item" type="primary" icon="ElIconEdit" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="formDialog" :title="dialogTitle" width="640px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="标签名" prop="label">
                <el-input v-model="temp.label" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="值" prop="value">
                <el-input v-model="temp.value" />
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

const props = defineProps({
  dictId: {
    type: String,
    default: ''
  }
})

const tableOptions = reactive({
  url: '/system/dict/items/list',
  page: true,
  where: {
    label: {
      label: '标签'
    },
    value: {
      label: '值'
    },
    dictId: props.dictId
  },
  cols: [
    {
      field: 'label',
      label: '标签'
    },
    {
      field: 'value',
      label: '值'
    },
    {
      field: 'sort',
      label: '排序'
    },
    {
      label: '排序',
      type: 'btns',
      width: 150,
      btns: [
        {
          label: '上移',
          type: 'primary',
          link: true,
          icon: 'ElIconSortUp',
          click: (row) => {
            proxy.$get('/system/dict/items/sort/up',{
              id: row.id,
              sort: row.sort,
              dictId: props.dictId
            }).then(() => {
              reloadTable()
            })
          }
        },
        {
          label: '下移',
          type: 'primary',
          link: true,
          icon: 'ElIconSortDown',
          click: (row) => {
            proxy.$get('/system/dict/items/sort/down',{
              id: row.id,
              sort: row.sort,
              dictId: props.dictId
            }).then(() => {
              reloadTable()
            })
          }
        }
      ]
    },
    {
      field: 'remarks',
      label: '备注'
    },
    {
      label: '操作',
      type: 'btns',
      width: 160,
      fixed: 'right',
      btns: [
        {
          permission: 'dict:items:save',
          label: '修改',
          type: 'primary',
          link: true,
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'dict:items:delete',
          label: '删除',
          type: 'primary',
          link: true,
          icon: 'ElIconDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/dict/items/delete',
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
const dialogTitle = ref('')
const rules = reactive({
  value: [{ required: true, message: '请输入值', trigger: 'change' }],
  label: [{ required: true, message: '请输入标签名', trigger: 'change' }],
  sort: [{ required: true, message: '请输入排序', trigger: 'change' }]
})
const temp = ref(getTemp())
const table = ref()
const formDialog = ref()
const dataForm = ref()

function reloadTable() {
  table.value.reload()
}

function getTemp() {
  return {
    id: '',
    value: '',
    label: '',
    dictId: props.dictId,
    sort: 0,
    remarks: ''
  }
}

function getSort() {
  proxy.$get('/system/dict/items/sort', { dictId: props.dictId }).then(res => {
    temp.value.sort = res.data
  })
}

function handleCreate() {
  temp.value = getTemp()
  getSort()
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
      proxy.$post('/system/dict/items/save', temp.value).then(() => {
        d.hideLoading()
        formDialog.value.hide()
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
  formDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

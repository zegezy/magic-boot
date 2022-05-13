<style>
.el-input-number .el-input__inner{
  text-align: left;
}
</style>

<template>
  <div class="app-container">

    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="机构搜索">
          <el-input v-model="searchValue" @input="searchOffice" placeholder="机构名称、机构编码"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button class="filter-item" type="primary" icon="ElIconSearch" @click="searchOffice">
            搜索
          </el-button>
          <el-button class="filter-item" icon="ElIconDelete" @click="() => { this.searchValue = ''; searchOffice() }">
            清空
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <el-row class="toolbar-container">
      <el-button class="filter-item" type="primary" icon="ElIconEdit" @click="addSubOffice('0')" v-permission="'office:save'">
        添加机构
      </el-button>
      <el-button type="primary" icon="ElIconSort" plain @click="expand">展开/折叠</el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" v-if="officeData && officeData.length > 0 && refreshTable" />

    <mb-dialog ref="officeFormDialog" width="700px" :title="dialogTitle" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="机构类型" prop="type">
                <mb-select v-model="temp.type" type="office_type" width="100%" :key="temp.type" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="上级机构" prop="pid">
                <el-tree-select v-model="temp.pid" :key="temp.pid" :data="officeTree" style="width: 100%" check-strictly />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="机构名称" prop="name">
                <el-input v-model="temp.name" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="机构编码" prop="code">
                <el-input v-model="temp.code" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="排序" prop="sort">
                <el-input-number v-model="temp.sort" controls-position="right" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>

import { ref, reactive, onMounted, watch, nextTick, getCurrentInstance } from 'vue'
const { proxy } = getCurrentInstance()
const refreshTable = ref(true)
const officeData = ref([])
const officeTree = ref([])
const searchValue = ref('')
const tableOptions = reactive({
  props: {
    'default-expand-all': true,
    'tree-props': { children: 'children', hasChildren: 'hasChildren' },
    'row-key': 'id'
  },
  showNo: false,
  page: false,
  cols: [
    {
      field: 'name',
      label: '机构名称',
      align: 'left',
      type: 'html'
    },
    {
      field: 'code',
      label: '机构编码',
      width: 300,
      align: 'left',
      type: 'html'
    },
    {
      field: 'type',
      dictType: 'office_type',
      label: '机构类型',
      width: 300,
      align: 'left'
    },
    {
      field: 'sort',
      label: '排序',
      width: 60
    },
    {
      label: '排序',
      type: 'btns',
      width: 150,
      btns: [
        {
          label: '上移',
          type: 'text',
          icon: 'ElIconSortUp',
          click: (row) => {
            proxy.$get('/system/office/sort/up',{
              id: row.id,
              pid: row.pid,
              sort: row.sort
            }).then(() => {
              reloadTable()
            })
          }
        },
        {
          label: '下移',
          type: 'text',
          icon: 'ElIconSortDown',
          click: (row) => {
            proxy.$get('/system/office/sort/down',{
              id: row.id,
              pid: row.pid,
              sort: row.sort
            }).then(() => {
              reloadTable()
            })
          }
        }
      ]
    },
    {
      label: '操作',
      type: 'btns',
      width: 310,
      fixed: 'right',
      align: 'left',
      btns: [
        {
          label: '添加下级机构',
          type: 'text',
          permission: 'office:save',
          icon: 'ElIconPlus',
          click: (row) => {
            addSubOffice(row.id)
          }
        },
        {
          label: '修改',
          type: 'text',
          permission: 'office:save',
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          label: '删除',
          type: 'text',
          permission: 'office:delete',
          icon: 'ElIconDelete',
          if: (row) => {
            return row.pid != '0';
          },
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/office/delete',
              id: row.id,
              done: () => reloadTable()
            })
          }
        },
        {
          permission: 'office:user:list',
          label: '用户列表',
          type: 'text',
          icon: 'ElIconUserFilled',
          click: (row) => {
            proxy.$router.push({
              path: '/system/user/user-list',
              query: { officeId: row.id }
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
  type: [{ required: true, message: '请选择机构类型', trigger: 'change' }],
  pid: [{ required: true, message: '请选择上级机构', trigger: 'change' }],
  name: [{ required: true, message: '请输入机构名称', trigger: 'change' }],
  code: [{ required: true, message: '请输入机构编码', trigger: 'change' }]
})
var searchTimeout = null
const officeFormDialog = ref()
const dataForm = ref()

onMounted(() => {
  reloadTable()
})

watch(officeData, () => {
  officeTree.value = [{
    label: '根节点',
    value: '0',
    children: proxy.$treeTable.genTree(officeData.value)
  }]
})

function expand(){
  refreshTable.value = false
  tableOptions.el["default-expand-all"] = !tableOptions.el["default-expand-all"]
  nextTick(() => refreshTable.value = true)
}

function searchOffice() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    if(searchValue.value){
      tableOptions.data = proxy.$treeTable.recursionSearch(['name', 'code'], proxy.$common.copyNew(officeData.value), searchValue.value)
    }else{
      tableOptions.data = officeData.value
    }
  },1000)
}

function getTemp() {
  return {
    id: '',
    name: '',
    sort: 0,
    pid: '',
    type: '',
    code: ''
  }
}

function resetTemp() {
  temp.value = getTemp()
}

function getSort() {
  proxy.$get('/system/office/sort', { pid: temp.value.pid }).then(res => {
    temp.value.sort = res.data
  })
}

function addSubOffice(id) {
  resetTemp()
  temp.value.pid = id
  temp.value.id = proxy.$common.uuid()
  getSort()
  dialogTitle.value = '添加'
  officeFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      if(temp.value.pid == temp.value.id){
        proxy.$notify({
          title: '失败',
          message: '上级机构不能选当前机构',
          type: 'error',
          duration: 2000
        })
        return
      }
      if(proxy.$treeTable.isChildren(proxy.$treeTable.queryChildren(officeData.value, temp.value.id), temp.value.pid)){
        proxy.$notify({
          title: '失败',
          message: '上级机构不能选当前机构子级',
          type: 'error',
          duration: 2000
        })
        return
      }
      proxy.$post('/system/office/save', temp.value).then(() => {
        d.hideLoading()
        proxy.$notify({
          title: '成功',
          message: dialogTitle.value + '成功',
          type: 'success',
          duration: 2000
        })
        reloadTable()
        officeFormDialog.value.hide()
      }).catch(() => d.hideLoading())
    }
  })
}

function reloadTable() {
  proxy.$get('/system/office/tree').then(res => {
    officeData.value = res.data.list
    tableOptions.data = officeData.value
  })
}

function handleUpdate(row) {
  for (var t in temp.value) {
    temp.value[t] = row[t]
  }
  temp.value.name = temp.value.name.replaceAll(/<font.*?>(.*?)<\/font>/g,'$1')
  dialogTitle.value = '修改'
  officeFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

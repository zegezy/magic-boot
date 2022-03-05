<style scoped>
.left{
  width: calc(20% - 20px);
  margin-right: 20px;
  float: left;
}
.right{
  width: 80%;
  float: right;
}
</style>

<template>
  <div class="app-container">
    <div class="left">
      <mb-tree url="office/tree" :el="{ 'expand-on-click-node': false,'show-checkbox': true }" :checked-ids="[tableOptions.where.officeId]" :expand="false" :search="true" search-width="100%" :checked="false" @check-change="checkChange" />
    </div>
    <div class="right">

      <mb-search :where="tableOptions.where" @search="reloadTable">
        <template #btns>
          <el-button :loading="downloadLoading" class="filter-item" icon="ElDownload" @click="handleDownload">
            导出
          </el-button>
        </template>
      </mb-search>

      <el-row style="margin-bottom: 15px">
        <el-button v-permission="'user:save'" class="filter-item" type="primary" icon="ElEdit" @click="handleCreate">
          添加
        </el-button>
        <mb-button v-permission="'user:delete'" :el="{ plain: true }" :request-url="'user/delete'" :btn-type="'delete'" :request-data="{ id: ids }" :after-handler="reloadTable" />
      </el-row>

      <mb-table ref="table" v-bind="tableOptions" @selection-change="selectionChange" />

      <mb-dialog ref="userFormDialog" :title="dialogTitle" @confirm-click="userForm.save($event)" width="670px">
        <template #content>
          <user-form ref="userForm" :key="'userForm'" @reload-table="reloadTable" />
        </template>
      </mb-dialog>
    </div>

    <div class="clear"></div>

  </div>
</template>

<script setup>
import UserForm from './user-form.vue'

import { ref, reactive, getCurrentInstance, onMounted, nextTick } from 'vue'

const { proxy } = getCurrentInstance()

const tableOptions = reactive({
  url: 'user/list',
  page: true,
  selection: true,
  where: {
    username: {
      type: 'input',
      label: '登录名称',
      value: ''
    },
    name: {
      type: 'input',
      label: '姓名/昵称',
      value: ''
    },
    roleId: {
      type: 'select',
      label: '角色',
      value: '',
      properties: {
        url: 'role/list?size=999999',
        labelField: 'name',
        valueField: 'id',
        el: { multiple: true }
      }
    }
  },
  cols: [
    {
      field: 'username',
      title: '登录名称',
      sortable: 'custom'
    },
    {
      field: 'name',
      title: '姓名/昵称',
      sortable: 'custom'
    },
    {
      field: 'officeName',
      title: '所属机构'
    },
    {
      field: 'roles',
      title: '角色'
    },
    {
      field: 'phone',
      title: '手机号',
      sortable: 'custom'
    },
    {
      field: 'isLogin',
      title: '禁止登录',
      type: 'switch',
      width: 100,
      change: (row) => {
        proxy.$get('/user/change/login/status', {
          id: row.id,
          isLogin: row.isLogin
        })
      }
    },
    {
      field: 'createDate',
      title: '创建时间',
      width: 180
    },
    {
      title: '操作',
      type: 'btns',
      width: 140,
      fixed: 'right',
      btns: [
        {
          permission: 'user:save',
          title: '修改',
          type: 'text',
          icon: 'ElEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'user:delete',
          title: '删除',
          type: 'text',
          icon: 'ElDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: 'user/delete',
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
const downloadLoading = ref(false)
const ids = ref([])
const userFormDialog = ref()
const table = ref()
const userForm = ref()

onMounted(() => {
  // setTimeout(function(){
    console.log(proxy.$route.query.roleId)
    if(proxy.$route.query.roleId){
      tableOptions.where.roleId.value = proxy.$route.query.roleId
    }
    if(proxy.$route.query.officeId){
      tableOptions.where.officeId = proxy.$route.query.officeId
    }
  // },1000)
})

function checkChange(values) {
  tableOptions.where.officeId = values
  nextTick(() => reloadTable())
}

function selectionChange(columns) {
  ids.value = columns.map(it => it['id']).join(',')
}

function reloadTable() {
  userFormDialog.value.hide()
  table.value.reloadList()
}

function handleCreate() {
  dialogTitle.value = '添加'
  userFormDialog.value.show()
  nextTick(() => {
    userForm.value.resetTemp()
  })
}

function handleUpdate(row) {
  dialogTitle.value = '修改'
  userFormDialog.value.show()
  nextTick(() => {
    userForm.value.getInfo(row)
  })
}

function handleDownload() {
  proxy.$common.exportExcel({
    url: tableOptions.url,
    headers: ['登录名称', '姓名'],
    columns: ['username', 'name'],
    where: tableOptions.where
  })
}

</script>

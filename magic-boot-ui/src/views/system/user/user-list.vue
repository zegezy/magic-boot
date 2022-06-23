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
      <mb-tree
        url="/system/office/tree"
        :props="{ 'expand-on-click-node': false,'show-checkbox': true }"
        :checked-ids="[tableOptions.where.officeId]"
        :expand="false"
        :search="true"
        search-width="100%"
        :checked="false"
        @check-change="checkChange"
      />
    </div>
    <div class="right">

      <mb-search :where="tableOptions.where" @search="reloadTable">
        <template #btns>
          <el-button class="filter-item" type="primary" icon="ElIconDownload" @click="table.exportExcel()">
            导出
          </el-button>
        </template>
      </mb-search>

      <el-row class="toolbar-container">
        <el-button v-permission="'user:save'" class="filter-item" type="primary" icon="ElIconEdit" @click="handleCreate">
          添加
        </el-button>
        <mb-button v-permission="'user:delete'" plain :request-url="'/system/user/delete'" :btn-type="'delete'" :request-data="{ id: ids }" :after-handler="reloadTable" />
        <mb-upload-file ref="importUserRef" action="/system/user/import/preview" label="导入用户" :show-tip="false" :show-file-list="false" :show-remove-tip="false" :on-success="importUserSuccess" />
      </el-row>

      <mb-table ref="table" v-bind="tableOptions" @selection-change="selectionChange" />

      <mb-dialog ref="previewUsersDialog" title="预览数据" @confirm-click="importUsers">
        <template #content>
          <mb-table v-bind="importUserTableOptions" />
        </template>
      </mb-dialog>

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

import { ref, reactive, getCurrentInstance, nextTick, watch } from 'vue'

const { proxy } = getCurrentInstance()
const importUserRef = ref()
const previewUsersDialog = ref()
const importUserTableOptions = reactive({

})
const sourceDatas = ref()
function importUserSuccess(res, file, fileList){
  const { datas } = res.data
  sourceDatas.value = res.data.sourceDatas
  console.log(JSON.stringify(res.data.sourceDatas))
  importUserRef.value.handlerRemove(file)
  if(datas && datas.length){
    var cols = []
    for(var key in datas[0]){
      cols.push({
        field: key,
        label: key
      })
    }
    previewUsersDialog.value.show(() => {
      importUserTableOptions.data = datas
      importUserTableOptions.cols = cols
    })
  }
}
function importUsers(){
  proxy.$postJson('/system/user/import', {
    datas: sourceDatas.value
  }).then(res => {
    if(res.data){
      proxy.$notify({
        title: '成功',
        message: '导入成功',
        type: 'success',
        duration: 2000
      })
      previewUsersDialog.value.hide()
      table.value.reload()
    }
  })
}
const tableOptions = reactive({
  url: '/system/user/list',
  page: true,
  selection: true,
  where: {
    username: {
      label: '登录名称'
    },
    name: {
      label: '姓名/昵称'
    },
    roleId: {
      component: 'select',
      label: '角色',
      props: {
        url: '/system/role/all',
        multiple: true
      }
    },
    officeId: ''
  },
  cols: [
    {
      field: 'username',
      label: '登录名称',
      sortable: 'custom'
    },
    {
      field: 'name',
      label: '姓名/昵称',
      sortable: 'custom'
    },
    {
      field: 'officeName',
      label: '所属机构'
    },
    {
      field: 'roles',
      label: '角色'
    },
    {
      field: 'phone',
      label: '手机号',
      sortable: 'custom'
    },
    {
      field: 'isLogin',
      label: '禁止登录',
      type: 'switch',
      exportTemplet: (row) => {
        return row.isLogin == 1 ? '已禁用' : '未禁用'
      },
      width: 100,
      if: (row) => {
        return row.id != '1'
      },
      change: (row) => {
        proxy.$get('/system/user/change/login/status', {
          id: row.id,
          isLogin: row.isLogin
        })
      }
    },
    {
      field: 'createDate',
      label: '创建时间',
      width: 180
    },
    {
      label: '操作',
      type: 'btns',
      width: 140,
      fixed: 'right',
      btns: [
        {
          permission: 'user:save',
          label: '修改',
          type: 'primary',
          link: true,
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'user:delete',
          label: '删除',
          type: 'primary',
          link: true,
          icon: 'ElIconDelete',
          if: (row) => {
            return row.id != '1'
          },
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/user/delete',
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

if(proxy.$route.query.roleId){
  tableOptions.where.roleId.value = proxy.$route.query.roleId
}

if(proxy.$route.query.officeId){
  tableOptions.where.officeId = proxy.$route.query.officeId
}

function checkChange(values) {
  tableOptions.where.officeId = values
  nextTick(() => reloadTable())
}

function selectionChange(columns) {
  ids.value = columns.map(it => it['id']).join(',')
}

function reloadTable() {
  userFormDialog.value.hide()
  table.value.reload()
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

</script>

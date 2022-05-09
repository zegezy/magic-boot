<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'role:save'" class="filter-item" type="primary" icon="ElIconPlus" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="roleFormDialog" :title="dialogTitle" width="900px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="角色名称" prop="name">
                <el-input v-model="temp.name" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="角色编码" prop="code">
                <el-input v-model="temp.code" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="24">
              <el-form-item label="角色描述" prop="descRibe">
                <el-input
                    type="textarea"
                    :rows="4"
                    placeholder="请输入描述"
                    v-model="temp.descRibe">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="菜单权限" prop="menus">
                <mb-tree ref="tree" :props="{ 'show-checkbox': true }" style="height: 270px; overflow: auto" url="/system/menu/tree" :search="true" v-model:select-values="temp.menus" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="数据权限" prop="permission">
                <mb-select v-model="temp.permission" :options="permissionData" />
                <mb-tree v-if="temp.permission == 1" style="height: 270px; overflow: auto" :props="{ 'check-strictly': true, 'show-checkbox': true }" ref="office" url="/system/office/tree" v-model:select-values="temp.offices" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

    <mb-dialog ref="assignPermissionsDialog" title="分配权限" width="550px" @confirm-click="assignPermissions.save($event)">
      <template #content>
        <role-assign-permissions ref="assignPermissions" :key="temp.id" :id="temp.id" @close="() => { assignPermissionsDialog.hide(); temp.id = '' }" />
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>
import { ref, reactive,getCurrentInstance, watch, nextTick } from 'vue'
import RoleAssignPermissions from './role-assign-permissions'

const { proxy } = getCurrentInstance()

const permissionData = reactive([{
  label: '全部',
  value: '0'
}, {
  label: '自定义',
  value: '1'
}, {
  label: '本级及子级',
  value: '2'
}, {
  label: '本级',
  value: '3'
}])
const assignPermissions = ref()
const assignPermissionsDialog = ref()
const table = ref()
const roleFormDialog = ref()
const dataForm = ref()
const tableOptions = reactive({
  url: '/system/role/list',
  where: {
    name: {
      type: 'input',
      label: '角色名称',
      value: ''
    }
  },
  cols: [
    {
      field: 'name',
      label: '角色名称'
    },
    {
      field: 'code',
      label: '角色编码'
    },
    {
      field: 'descRibe',
      label: '角色描述'
    },
    {
      field: 'permission',
      label: '数据权限',
      templet: (row) => {
        return permissionData[row.permission].label
      }
    },
    {
      label: '操作',
      type: 'btns',
      width: 270,
      fixed: 'right',
      btns: [
        {
          permission: 'role:save',
          label: '修改',
          type: 'text',
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          permission: 'role:delete',
          label: '删除',
          type: 'text',
          icon: 'ElIconDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/role/delete',
              id: row.id,
              done: () => reloadTable()
            })
          }
        },
        {
          permission: 'role:permission',
          label: '权限',
          type: 'text',
          icon: 'ElIconPlus',
          click: (row) => {
            temp.value.id = row.id
            assignPermissionsDialog.value.show()
          }
        },
        {
          permission: 'role:user:list',
          label: '用户列表',
          type: 'text',
          icon: 'ElIconUserFilled',
          click: (row) => {
            proxy.$router.push({
              path: '/system/user/user-list',
              query: { roleId: row.id }
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
  name: [{ required: true, message: '请输入角色名称', trigger: 'change' }],
  code: [{ required: true, message: '请输入角色编码', trigger: 'change' }]
})
const downloadLoading = ref(false)

watch(() => temp.value.permission,() => {
  if(temp.value.permission != 1){
    temp.value.offices = ''
  }
})

function reloadTable() {
  table.value.reload()
}

function getTemp(){
  return {
    id: '',
    name: '',
    menus: '',
    offices: '',
    permission: '0',
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
  roleFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      proxy.$post('/system/role/save', temp.value).then(() => {
        d.hideLoading()
        reloadTable()
        roleFormDialog.value.hide()
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
  proxy.$get('/system/menu/by/role',{ roleId: row.id }).then(res => {
    temp.value.menus = res.data.join(',')
  })
  proxy.$get('/system/office/by/role',{ roleId: row.id }).then(res => {
    temp.value.offices = res.data.join(',')
  })
  dialogTitle.value = '修改'
  roleFormDialog.value.show()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

</script>

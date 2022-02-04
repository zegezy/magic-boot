<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'role:save'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="roleFormDialog" :title="dialogTitle" width="1000px" @confirm-click="save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="120px" style="width: 900px;">
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
                <mb-tree ref="tree" :el="{ 'show-checkbox': true }" max-height="320px" url="menu/tree" :search="true" :select-values.sync="temp.menus" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="数据权限" prop="permission">
                <mb-select v-model="temp.permission" :data="permissionData" />
                <mb-tree v-if="temp.permission == 1" max-height="320px" :el="{ 'check-strictly': true, 'show-checkbox': true }" ref="office" url="office/tree" :select-values.sync="temp.offices" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

    <mb-dialog ref="assignPermissionsDialog" title="分配权限" width="750" @confirm-click="$refs.assignPermissions.save()">
      <template #content>
        <role-assign-permissions ref="assignPermissions" :key="Math.random()" :id="temp.id" @close="() => { $refs.assignPermissionsDialog.hide(); temp.id = '' }" />
      </template>
    </mb-dialog>

  </div>
</template>

<script>
import RoleAssignPermissions from './role-assign-permissions'

export default {
  name: 'RoleList',
  components: { RoleAssignPermissions },
  data() {
    return {
      permissionData: [{
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
      }],
      tableOptions: {
        url: 'role/list',
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
            title: '角色名称'
          },
          {
            field: 'code',
            title: '角色编码'
          },
          {
            field: 'descRibe',
            title: '角色描述'
          },
          {
            field: 'permission',
            title: '数据权限',
            templet: (row) => {
              return this.permissionData[row.permission].label
            }
          },
          {
            title: '操作',
            type: 'btns',
            width: 200,
            fixed: 'right',
            btns: [
              {
                permission: 'role:save',
                title: '修改',
                type: 'text',
                icon: 'el-icon-edit',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'role:delete',
                title: '删除',
                type: 'text',
                icon: 'el-icon-delete',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'role/delete',
                    id: row.id,
                    done: () => this.reloadTable()
                  })
                }
              },
              {
                permission: 'role:permission',
                title: '权限',
                type: 'text',
                icon: 'el-icon-plus',
                click: (row) => {
                  this.temp.id = row.id
                  this.$refs.assignPermissionsDialog.show()
                }
              }
            ]
          }
        ]
      },
      dialogTitle: '',
      temp: this.getTemp(),
      rules: {
        name: [{ required: true, message: '请输入角色名称', trigger: 'change' }],
        code: [{ required: true, message: '请输入角色编码', trigger: 'change' }]
      },
      downloadLoading: false
    }
  },
  watch: {
    'temp.permission'() {
      if(this.temp.permission != 1){
        this.temp.offices = ''
      }
    }
  },
  methods: {
    reloadTable() {
      this.$refs.table.reloadList()
    },
    getTemp(){
      return {
        id: '',
        name: '',
        menus: '',
        offices: '',
        permission: '0',
        code: '',
        descRibe: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    handleCreate() {
      this.resetTemp()
      this.dialogTitle = '添加'
      this.$refs.roleFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('role/save', this.temp).then(() => {
            this.reloadTable()
            this.$refs.roleFormDialog.hide()
            this.$notify({
              title: '成功',
              message: this.dialogTitle + '成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      this.$get('menu/by/role',{ roleId: row.id }).then(res => {
        this.temp.menus = res.data.join(',')
      })
      this.$get('office/by/role',{ roleId: row.id }).then(res => {
        this.temp.offices = res.data.join(',')
      })
      this.dialogTitle = '修改'
      this.$refs.roleFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}
</script>

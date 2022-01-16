<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="角色名称">
          <el-input v-model="tableOptions.where.name" placeholder="请输入角色名称" style="width: 200px;" class="filter-item" />
        </el-form-item>
        <el-button class="filter-item" type="primary" icon="el-icon-search" @click="reloadTable">
          搜索
        </el-button>
        <el-button class="filter-item" icon="el-icon-delete" @click="tableOptions.where = {}">
          清空
        </el-button>
      </el-form>
    </div>

    <el-row class="toolbar-container">
      <el-button v-permission="'role:save'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <pd-table ref="table" v-bind="tableOptions" />

    <pd-dialog ref="roleFormDialog" @confirm-click="save()">
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
                <pd-tree ref="tree" :el="{ 'show-checkbox': true }" max-height="320px" url="menu/tree" :search="true" :select-values.sync="temp.menus" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="数据权限" prop="permission">
                <pd-select v-model="temp.permission" :data="permissionData" />
                <pd-tree v-if="temp.permission == 1" max-height="320px" :el="{ 'check-strictly': true, 'show-checkbox': true }" ref="office" url="office/tree" :select-values.sync="temp.offices" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </pd-dialog>

    <pd-dialog ref="assignPermissionsDialog" width="40%" @confirm-click="$refs.assignPermissions.save()">
      <template #content>
        <role-assign-permissions ref="assignPermissions" :key="Math.random()" :id="temp.id" @close="() => { $refs.assignPermissionsDialog.hide(); temp.id = '' }" />
      </template>
    </pd-dialog>

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
        value: 0
      }, {
        label: '自定义',
        value: 1
      }, {
        label: '本级及子级',
        value: 2
      }, {
        label: '本级',
        value: 3
      }],
      tableOptions: {
        url: 'role/list',
        where: {
          name: ''
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
      temp: this.getTemp(),
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
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
        permission: 0,
        code: '',
        descRibe: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    handleCreate() {
      this.resetTemp()
      this.dialogStatus = 'create'
      this.$refs.roleFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('role/save', this.temp).then((response) => {
            this.reloadTable()
            this.$refs.roleFormDialog.hide()
            this.$notify({
              title: '成功',
              message: (this.dialogStatus === 'create' ? '创建' : '修改') + '成功',
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
      this.dialogStatus = 'update'
      this.$refs.roleFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}
</script>

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
        <el-button v-permission="'role:save'" class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
      </el-form>
    </div>

    <pd-table ref="table" v-bind="tableOptions" />

    <pd-dialog :visible.sync="dialogFormVisible" @confirm-click="save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="120px" style="width: 400px; margin-left:50px;">
          <el-form-item label="角色名称" prop="name">
            <el-input v-model="temp.name" />
          </el-form-item>
          <el-form-item label="选择菜单">
            <el-tree
              ref="tree"
              :data="menuTree"
              show-checkbox
              node-key="id"
              :default-expand-all="true"
              :props="defaultProps"
            />
          </el-form-item>
        </el-form>
      </template>
    </pd-dialog>

  </div>
</template>

<script>
import { getMenusByRoleId } from '@/api/menu'
import { getMenuTree } from '@/api/menu'

export default {
  name: 'RoleList',
  filters: {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft: 'info',
        deleted: 'danger'
      }
      return statusMap[status]
    }
  },
  data() {
    return {
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
            title: '操作',
            type: 'btns',
            width: 200,
            fixed: 'right',
            btns: [
              {
                permission: 'role:save',
                title: '修改',
                type: 'primary',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'role:delete',
                title: '删除',
                type: 'danger',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'role/delete',
                    id: row.id,
                    done: () => this.reloadTable()
                  })
                }
              }
            ]
          }
        ]
      },
      menuTree: [],
      defaultProps: {
        children: 'children',
        label: 'name'
      },
      selectMenus: [],
      temp: {
        id: '',
        name: '',
        menus: []
      },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      rules: {
        name: [{ required: true, message: '请输入角色名称', trigger: 'change' }]
      },
      downloadLoading: false
    }
  },
  created() {
    getMenuTree().then(response => {
      const { data } = response
      this.menuTree = data.list
    })
  },
  methods: {
    reloadTable() {
      this.$refs.table.reloadList()
    },
    resetTemp() {
      this.temp = {
        id: '',
        name: '',
        menus: []
      }
    },
    handleCreate() {
      this.cancelSelectMenu()
      this.resetTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.selectMenus = []
      var checkedNodes = this.$refs.tree.getCheckedNodes(false, true)
      for (var i = 0; i < checkedNodes.length; i++) {
        this.selectMenus.push(checkedNodes[i].id)
      }
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.temp.menus = this.selectMenus.join(',')
          this.$post('role/save', this.temp).then((response) => {
            this.reloadTable()
            this.dialogFormVisible = false
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
    cancelSelectMenu() {
      if (this.$refs.tree) {
        for (var i in this.menuTree) {
          var menu = this.menuTree[i]
          this.$refs.tree.setChecked(menu, false, true)
        }
      }
    },
    handleUpdate(row) {
      this.cancelSelectMenu()
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      getMenusByRoleId(row.id).then(response => {
        const { data } = response
        for (var i = 0; i < data.length; i++) {
          this.$refs.tree.setChecked(data[i], true, false)
        }
      })
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}
</script>

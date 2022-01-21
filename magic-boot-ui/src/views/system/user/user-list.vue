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
      <pd-tree url="office/tree" :el="{ 'expand-on-click-node': false,'show-checkbox': true }" :expand="false" :search="true" search-width="100%" :checked="false" @check-change="checkChange" />
    </div>
    <div class="right">
      <div class="filter-container">
        <el-form :inline="true">
          <el-form-item label="登录名称">
            <el-input v-model="tableOptions.where.username" placeholder="登录名称" style="width: 200px;" class="filter-item" />
          </el-form-item>
          <el-form-item label="姓名/昵称">
            <el-input v-model="tableOptions.where.name" placeholder="姓名/昵称" style="width: 200px;" class="filter-item" />
          </el-form-item>
          <el-button class="filter-item" type="primary" icon="el-icon-search" @click="reloadTable">
            搜索
          </el-button>
          <el-button :loading="downloadLoading" class="filter-item" icon="el-icon-delete" @click="reset">
            清空
          </el-button>
          <el-button :loading="downloadLoading" class="filter-item" icon="el-icon-download" @click="handleDownload">
            导出
          </el-button>
        </el-form>
      </div>

      <el-row style="margin-bottom: 15px">
        <el-button v-permission="'user:save'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
        <pd-button :el="{ plain: true }" :request-url="'user/delete'" :btn-type="'delete'" :request-data="{ id: ids }" :after-handler="reloadTable" />
      </el-row>

      <pd-table ref="table" v-bind="tableOptions" @selection-change="selectionChange" />

      <pd-dialog ref="userFormDialog" @confirm-click="$refs.userForm.save()" width="40%">
        <template #content>
          <user-form ref="userForm" :dialog-status="dialogStatus" @reload-table="reloadTable" />
        </template>
      </pd-dialog>
    </div>

    <div class="clear"></div>

  </div>
</template>

<script>
import UserForm from './user-form.vue'
import PdTree from "@/components/Psyduck/pd-tree";

export default {
  name: 'UserList',
  components: {PdTree, UserForm },
  data() {
    return {
      tableOptions: {
        url: 'user/list',
        page: true,
        selection: true,
        where: {
          username: '',
          name: ''
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
            field: 'phone',
            title: '手机号',
            width: 200,
            sortable: 'custom'
          },
          {
            field: 'isLogin',
            title: '禁止登录',
            type: 'switch',
            width: 100,
            change: (row) => {
              this.$get('/user/change/login/status', {
                id: row.id,
                isLogin: row.isLogin
              })
            }
          },
          {
            field: 'createDate',
            title: '创建时间'
          },
          {
            title: '操作',
            type: 'btns',
            width: 200,
            fixed: 'right',
            btns: [
              {
                permission: 'user:save',
                title: '修改',
                type: 'primary',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'user:delete',
                title: '删除',
                type: 'danger',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'user/delete',
                    id: row.id,
                    done: () => this.reloadTable()
                  })
                }
              }
            ]
          }
        ]
      },
      dialogStatus: '',
      downloadLoading: false,
      ids: []
    }
  },
  methods: {
    reset() {
      this.tableOptions.where = {}
      this.$nextTick(() => this.reloadTable())
    },
    checkChange(values) {
      this.tableOptions.where.officeId = values
      this.reloadTable()
    },
    selectionChange(columns) {
      this.ids = columns.map(it => it['id']).join(',')
    },
    reloadTable() {
      this.$refs.userFormDialog.hide()
      this.$refs.table.reloadList()
    },
    handleCreate() {
      this.dialogStatus = 'create'
      this.$refs.userFormDialog.show()
      this.$nextTick(() => { this.$refs.userForm.resetTemp() })
    },
    handleUpdate(row) {
      this.dialogStatus = 'update'
      this.$refs.userFormDialog.show()
      this.$nextTick(() => {
        this.$refs.userForm.getInfo(row)
      })
    },
    handleDownload() {
      this.$common.exportExcel({
        url: this.tableOptions.url,
        headers: ['登录名称', '姓名'],
        columns: ['username', 'name'],
        where: this.tableOptions.where
      })
    }
  }
}
</script>

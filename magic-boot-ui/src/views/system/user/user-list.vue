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
      <mb-tree url="office/tree" :el="{ 'expand-on-click-node': false,'show-checkbox': true }" :expand="false" :search="true" search-width="100%" :checked="false" @check-change="checkChange" />
    </div>
    <div class="right">

      <mb-search :where="tableOptions.where" @search="reloadTable">
        <template #btns>
          <el-button :loading="downloadLoading" class="filter-item" icon="el-icon-download" @click="handleDownload">
            导出
          </el-button>
        </template>
      </mb-search>

      <el-row style="margin-bottom: 15px">
        <el-button v-permission="'user:save'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
        <mb-button :el="{ plain: true }" :request-url="'user/delete'" :btn-type="'delete'" :request-data="{ id: ids }" :after-handler="reloadTable" />
      </el-row>

      <mb-table ref="table" v-bind="tableOptions" @selection-change="selectionChange" />

      <mb-dialog ref="userFormDialog" :title="dialogTitle" @confirm-click="$refs.userForm.save()" width="770px">
        <template #content>
          <user-form ref="userForm" :dialog-status="dialogTitle" @reload-table="reloadTable" />
        </template>
      </mb-dialog>
    </div>

    <div class="clear"></div>

  </div>
</template>

<script>
import UserForm from './user-form.vue'

export default {
  name: 'UserList',
  components: { UserForm },
  data() {
    return {
      tableOptions: {
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
      dialogTitle: '',
      downloadLoading: false,
      ids: []
    }
  },
  methods: {
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
      this.dialogTitle = '添加'
      this.$refs.userFormDialog.show()
      this.$nextTick(() => { this.$refs.userForm.resetTemp() })
    },
    handleUpdate(row) {
      this.dialogTitle = '修改'
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

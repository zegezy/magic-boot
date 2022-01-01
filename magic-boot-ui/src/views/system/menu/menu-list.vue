<style scoped>
.icon-btn >>> i{
  font-size: 25px;
}
</style>

<template>
  <div class="app-container">

    <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubMenu('0')">
      添加菜单
    </el-button>

    <pd-table ref="table" v-bind="tableOptions" />

    <pd-dialog ref="menuFormDialog" width="800px" :title="textMap[dialogStatus]" @confirm-click="save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="100px" style="width: 600px; margin-left:50px;">
          <el-form-item label="菜单名称" prop="name">
            <el-input v-model="temp.name" />
          </el-form-item>
          <el-form-item label="菜单链接" prop="url">
            <el-input v-model="temp.url" />
          </el-form-item>
          <el-form-item label="权限标识" prop="permission">
            <el-input v-model="temp.permission" />
          </el-form-item>
          <el-form-item label="图标" prop="icon">
            <a @click="openIcons">
              <el-input placeholder="请选择图标" v-model="temp.icon" class="input-with-select">
                <el-button class="icon-btn" slot="append">
                  <i v-html="generateIconCode(temp.icon)"></i>
                </el-button>
              </el-input>
            </a>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model="temp.sort" />
          </el-form-item>
          <el-form-item label="描述">
            <el-input v-model="temp.descRibe" :autosize="{ minRows: 4, maxRows: 6}" type="textarea" />
          </el-form-item>
          <el-form-item label="是否显示">
            <el-checkbox v-model="temp.isShow">显示</el-checkbox>
          </el-form-item>
        </el-form>
      </template>
    </pd-dialog>

    <pd-dialog ref="iconDialog">
      <template #content>
        <menu-icons :select-icon="selectIcon" />
      </template>
    </pd-dialog>

  </div>
</template>

<script>
import MenuIcons from './menu-icons'

export default {
  components: { MenuIcons },
  data() {
    return {
      tableOptions: {
        el: {
          'default-expand-all': true,
          'tree-props': { children: 'children', hasChildren: 'hasChildren' },
          'row-key': 'id'
        },
        showNo: false,
        url: 'menu/tree',
        page: false,
        cols: [
          {
            field: 'name',
            title: '菜单名称',
            align: 'left'
          },
          {
            field: 'url',
            title: '路径',
            align: 'left'
          },
          {
            field: 'permission',
            title: '权限标识',
            width: 150,
            align: 'left'
          },
          {
            field: 'sort',
            title: '排序',
            width: 60
          },
          {
            field: 'isShow',
            title: '是否显示',
            type: 'switch',
            width: 100,
            change: (row) => {
              this.$get('menu/change/show', {
                id: row.id,
                isShow: row.isShow
              })
            }
          },
          {
            title: '操作',
            type: 'btns',
            width: 262,
            fixed: 'right',
            align: 'left',
            btns: [
              {
                title: '添加下级菜单',
                type: 'text',
                click: (row) => {
                  this.addSubMenu(row.id)
                }
              },
              {
                title: '编辑',
                type: 'text',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                title: '删除',
                type: 'text',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'menu/delete',
                    id: row.id,
                    done: () => this.reloadTable()
                  })
                }
              }
            ]
          }
        ]
      },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      temp: this.getTemp(),
      listConfigDialogVisible: false,
      formConfigDialogVisible: false,
      rules: {
        name: [{ required: true, message: '请输入菜单名称', trigger: 'change' }]
      }
    }
  },
  methods: {
    generateIconCode(symbol) {
      return `<svg style="width: 20px;height: 20px" aria-hidden="true" class="svg-icon disabled"><use href="#icon-${symbol}"></use></svg>`
    },
    selectIcon(symbol) {
      this.$set(this.temp, 'icon', symbol)
      this.$refs.iconDialog.hide()
    },
    openIcons() {
      this.$refs.iconDialog.show()
    },
    getTemp() {
      return {
        id: '',
        name: '',
        url: '',
        permission: '',
        sort: 0,
        descRibe: '',
        isShow: true,
        pid: '',
        icon: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    getSort() {
      this.$get('menu/sort', { pid: this.temp.pid }).then(res => {
        this.temp.sort = res.data
      })
    },
    addSubMenu(id) {
      this.resetTemp()
      this.temp.pid = id
      this.temp.id = this.$common.uuid()
      this.getSort()
      this.dialogStatus = 'create'
      this.$refs.menuFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.temp.isShow = this.temp.isShow === true ? 1 : 0
          this.$post('menu/save', this.temp).then(() => {
            this.reloadTable()
            this.$refs.menuFormDialog.hide()
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
    reloadTable() {
      this.$refs.table.reloadList()
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        if (t === 'isShow') {
          if (row[t] === 1) {
            this.temp[t] = true
          } else {
            this.temp[t] = false
          }
        } else {
          this.temp[t] = row[t]
        }
      }
      this.dialogStatus = 'update'
      this.$refs.menuFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}

</script>

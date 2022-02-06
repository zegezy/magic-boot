<template>
  <div class="app-container">

    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="菜单搜索">
          <el-input v-model="searchValue" @input="searchMenu" placeholder="菜单名称、链接、权限标识" style="width: 200px"></el-input>
        </el-form-item>
        <el-button class="filter-item" type="primary" icon="el-icon-search" @click="searchMenu">
          搜索
        </el-button>
        <el-button class="filter-item" icon="el-icon-delete" @click="() => { this.searchValue = ''; searchMenu() }">
          清空
        </el-button>
      </el-form>
    </div>

    <el-row class="toolbar-container">
      <el-button class="filter-item" type="primary" icon="el-icon-edit" @click="addSubMenu('0')" v-permission="'menu:save'">
        添加菜单
      </el-button>
      <el-button type="primary" icon="el-icon-sort" plain @click="expand">展开/折叠</el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" v-if="menuData && menuData.length > 0 && refreshTable" />

    <mb-dialog ref="menuFormDialog" width="950px" :title="dialogTitle" @confirm-click="$refs.menuForm.save($event)">
      <template #content>
        <menu-form ref="menuForm" :menu-tree="menuTree" @reload-table="reloadTable" />
      </template>
    </mb-dialog>

  </div>
</template>

<script>
import MenuForm from './menu-form'

export default {
  name: 'MenuList',
  components: { MenuForm },
  data() {
    return {
      refreshTable: true,
      menuTree: [],
      menuData: [],
      searchValue: '',
      tableOptions: {
        el: {
          'default-expand-all': true,
          'tree-props': { children: 'children', hasChildren: 'hasChildren' },
          'row-key': 'id'
        },
        showNo: false,
        page: false,
        cols: [
          {
            field: 'name',
            title: '菜单名称',
            align: 'left',
            type: 'html'
          },
          {
            field: 'url',
            title: '路径',
            align: 'left',
            type: 'html'
          },
          {
            field: 'permission',
            title: '权限标识',
            width: 150,
            align: 'left',
            type: 'html'
          },
          {
            field: 'icon',
            title: '图标',
            width: 45,
            align: 'left',
            templet: (row) => {
              return this.generateIconCode(row.icon)
            }
          },
          {
            field: 'sort',
            title: '序号',
            width: 60
          },
          {
            title: '排序',
            type: 'btns',
            width: 150,
            btns: [
              {
                title: '上移',
                type: 'text',
                icon: 'el-icon-sort-up',
                click: (row) => {
                  this.$get('menu/sort/up',{
                    id: row.id,
                    pid: row.pid,
                    sort: row.sort
                  }).then(() => {
                    this.reloadTable()
                  })
                }
              },
              {
                title: '下移',
                type: 'text',
                icon: 'el-icon-sort-down',
                click: (row) => {
                  this.$get('menu/sort/down',{
                    id: row.id,
                    pid: row.pid,
                    sort: row.sort
                  }).then(() => {
                    this.reloadTable()
                  })
                }
              }
            ]
          },
          {
            field: 'isShow',
            title: '是否显示',
            type: 'switch',
            width: 100,
            change: (row) => {
              this.$get('menu/change', {
                id: row.id,
                isShow: row.isShow
              })
            }
          },
          {
            field: 'keepAlive',
            title: '是否缓存',
            type: 'switch',
            width: 100,
            change: (row) => {
              this.$get('menu/change', {
                id: row.id,
                keepAlive: row.keepAlive
              })
            }
          },
          {
            title: '操作',
            type: 'btns',
            width: 260,
            fixed: 'right',
            align: 'left',
            btns: [
              {
                title: '添加下级菜单',
                type: 'text',
                permission: 'menu:save',
                icon: 'el-icon-plus',
                click: (row) => {
                  this.addSubMenu(row.id)
                }
              },
              {
                title: '修改',
                type: 'text',
                permission: 'menu:save',
                icon: 'el-icon-edit',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                title: '删除',
                type: 'text',
                permission: 'menu:delete',
                icon: 'el-icon-delete',
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
      dialogTitle: '',
      searchTimeout: ''
    }
  },
  mounted() {
    this.reloadTable()
  },
  watch: {
    menuData() {
      this.menuTree = [{
        label: '根节点',
        id: '0',
        children: this.$treeTable.genTree(this.menuData)
      }]
    }
  },
  methods: {
    expand(){
      this.refreshTable = false
      this.tableOptions.el["default-expand-all"] = !this.tableOptions.el["default-expand-all"]
      this.$nextTick(() => this.refreshTable = true)
    },
    searchMenu() {
      var _this = this
      clearTimeout(this.searchTimeout)
      this.searchTimeout = setTimeout(() => {
        if(_this.searchValue){
          _this.$set(_this.tableOptions, 'data', _this.$treeTable.recursionSearch(['name', 'url', 'permission'], _this.$common.copyNew(_this.menuData), _this.searchValue))
        }else{
          _this.$set(_this.tableOptions, 'data', _this.menuData)
        }
      },500)
    },
    addSubMenu(id) {
      this.dialogTitle = '添加'
      this.$refs.menuFormDialog.show()
      this.$nextTick(() => {
        this.$refs.menuForm.addSubMenu(id)
      })
    },
    reloadTable() {
      this.$refs.menuFormDialog.hide()
      this.$get('menu/tree').then(res => {
        this.menuData = res.data.list
        this.$set(this.tableOptions, 'data', this.menuData)
      })
    },
    handleUpdate(row) {
      this.dialogTitle = '修改'
      this.$refs.menuFormDialog.show()
      this.$nextTick(() => {
        this.$refs.menuForm.getInfo(row);
      })
    },
    generateIconCode(symbol) {
      return `<svg style="width: 20px;height: 20px;fill: #999" aria-hidden="true" class="svg-icon disabled"><use href="#icon-${symbol}"></use></svg>`
    }
  }
}

</script>

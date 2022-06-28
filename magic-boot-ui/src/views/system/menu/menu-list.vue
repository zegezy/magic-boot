<template>
  <div class="app-container">

    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="菜单搜索">
          <el-input v-model="searchValue" @input="searchMenu" placeholder="菜单名称、链接、权限标识" style="width: 200px"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button class="filter-item" type="primary" icon="ElIconSearch" @click="searchMenu">
            搜索
          </el-button>
          <el-button class="filter-item" icon="ElIconDelete" @click="() => { searchValue = ''; searchMenu() }">
            清空
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <el-row class="toolbar-container">
      <el-button class="filter-item" type="primary" icon="ElIconPlus" @click="addSubMenu('0')" v-permission="'menu:save'">
        添加菜单
      </el-button>
      <el-button type="primary" icon="ElIconSort" plain @click="expand">展开/折叠</el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" v-if="menuData && menuData.length > 0 && refreshTable" />

    <mb-dialog ref="menuFormDialog" width="1050px" :title="dialogTitle" @confirm-click="menuFormRef.save($event)">
      <template #content>
        <menu-form ref="menuFormRef" :title="dialogTitle" :menu-tree="menuTree" :menu-data="menuData" @reload-table="reloadTable" />
      </template>
    </mb-dialog>

  </div>
</template>

<script setup>

import { ref,reactive, onMounted, getCurrentInstance, nextTick, watch } from 'vue'
import MenuForm from './menu-form'

const { proxy } = getCurrentInstance()

const refreshTable = ref(true)
let menuTree = ref([])
const menuData = ref([])
let searchValue = ref('')
const tableOptions = reactive({
  props: {
    'tree-props': { children: 'children', hasChildren: 'hasChildren' },
    'row-key': 'id'
  },
  showNo: false,
  page: false,
  cols: [
    {
      field: 'name',
      label: '菜单名称',
      align: 'left',
      type: 'html'
    },
    {
      field: 'url',
      label: '路径',
      align: 'left',
      type: 'html'
    },
    {
      field: 'permission',
      label: '权限标识',
      width: 150,
      align: 'left',
      type: 'html'
    },
    {
      field: 'icon',
      label: '图标',
      width: 55,
      align: 'center',
      templet: (row) => {
        return generateIconCode(row.icon)
      }
    },
    {
      field: 'sort',
      label: '排序',
      width: 60
    },
    {
      label: '排序',
      type: 'btns',
      width: 180,
      btns: [
        {
          label: '上移',
          type: 'primary',
          link: true,
          icon: 'ElIconSortUp',
          click: (row) => {
            proxy.$get('/system/menu/sort/up',{
              id: row.id,
              pid: row.pid,
              sort: row.sort
            }).then(() => {
              reloadTable()
            })
          }
        },
        {
          label: '下移',
          type: 'primary',
          link: true,
          icon: 'ElIconSortDown',
          click: (row) => {
            proxy.$get('/system/menu/sort/down',{
              id: row.id,
              pid: row.pid,
              sort: row.sort
            }).then(() => {
              reloadTable()
            })
          }
        }
      ]
    },
    {
      field: 'isShow',
      label: '是否显示',
      type: 'switch',
      width: 100,
      change: (row) => {
        proxy.$get('/system/menu/change', {
          id: row.id,
          isShow: row.isShow
        })
      }
    },
    {
      field: 'keepAlive',
      label: '是否缓存',
      type: 'switch',
      width: 100,
      change: (row) => {
        proxy.$get('/system/menu/change', {
          id: row.id,
          keepAlive: row.keepAlive
        })
      }
    },
    {
      label: '操作',
      type: 'btns',
      width: 280,
      fixed: 'right',
      align: 'left',
      btns: [
        {
          label: '添加下级菜单',
          type: 'primary',
          link: true,
          permission: 'menu:save',
          icon: 'ElIconPlus',
          click: (row) => {
            addSubMenu(row.id)
          }
        },
        {
          label: '修改',
          type: 'primary',
          link: true,
          permission: 'menu:save',
          icon: 'ElIconEdit',
          click: (row) => {
            handleUpdate(row)
          }
        },
        {
          label: '删除',
          type: 'primary',
          link: true,
          permission: 'menu:delete',
          icon: 'ElIconDelete',
          click: (row) => {
            proxy.$common.handleDelete({
              url: '/system/menu/delete',
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
var searchTimeout = null
const menuFormDialog = ref()
const menuFormRef = ref()

function reloadTable(){
  proxy.$get('/system/menu/tree').then(res => {
    menuData.value = res.data.list
    tableOptions.data = menuData.value
  })
}

function expand(){
  refreshTable.value = false
  tableOptions.props["default-expand-all"] = !tableOptions.props["default-expand-all"]
  nextTick(() => refreshTable.value = true)
}

function searchMenu() {
  refreshTable.value = false
  tableOptions.props["default-expand-all"] = true
  nextTick(() => refreshTable.value = true)
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    if(searchValue.value){
      tableOptions.data = proxy.$treeTable.recursionSearch(['name', 'url', 'permission'], proxy.$common.copyNew(menuData.value), searchValue.value)
    }else{
      tableOptions.data = menuData.value
    }
  },500)
}

function addSubMenu(id) {
  dialogTitle.value = '添加'
  menuFormDialog.value.show()
  nextTick(() => {
    menuFormRef.value.addSubMenu(id)
  })
}

function handleUpdate(row) {
  dialogTitle.value = '修改'
  menuFormDialog.value.show()
  nextTick(() => {
    menuFormRef.value.getInfo(row);
  })
}

function generateIconCode(symbol) {
  return `<svg style="width: 20px;height: 20px;fill: #999" aria-hidden="true" class="svg-icon disabled"><use href="#icon-${symbol}"></use></svg>`
}

onMounted(() => reloadTable())

watch(menuData, () => {
  menuTree.value = [{
    label: '根节点',
    value: '0',
    children: proxy.$treeTable.genTree(menuData.value)
  }]
})

</script>

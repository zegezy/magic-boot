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

    <el-row style="margin-bottom: 5px">
      <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubMenu('0')">
        添加菜单
      </el-button>
    </el-row>

    <pd-table ref="table" v-bind="tableOptions" v-if="menuData && menuData.length > 0" />

    <pd-dialog ref="menuFormDialog" width="800px" :title="textMap[dialogStatus]" @confirm-click="save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px" style="width: 600px; margin-left:50px;">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="菜单类型" prop="type">
                <el-radio-group v-model="temp.type" size="small">
                  <el-radio-button label="menu">菜单</el-radio-button>
                  <el-radio-button label="button">按钮</el-radio-button>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="上级菜单" prop="pid">
                <treeselect v-model="temp.pid" :options="menuTree" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item label="菜单名称" prop="name">
            <el-input v-model="temp.name" />
          </el-form-item>
          <el-form-item label="菜单链接" prop="url" v-if="temp.type == 'menu'">
            <el-input v-model="temp.url" />
          </el-form-item>
          <el-form-item label="权限标识" prop="permission">
            <el-input v-model="temp.permission" />
          </el-form-item>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="图标" prop="icon" v-if="temp.type == 'menu'">
                <a @click="openIcons">
                  <el-input placeholder="请选择图标" v-model="temp.icon" class="input-with-select">
                    <el-button class="icon-btn" slot="append">
                      <i v-html="generateIconCode(temp.icon)"></i>
                    </el-button>
                  </el-input>
                </a>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="排序" prop="sort">
                <el-input-number v-model="temp.sort" controls-position="right" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="是否显示" v-if="temp.type == 'menu'">
                <el-switch v-model="temp.isShow" :active-value="1" :inactive-value="0"></el-switch>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="是否缓存" v-if="temp.type == 'menu'">
                <el-switch v-model="temp.keepAlive" :active-value="1" :inactive-value="0"></el-switch>
              </el-form-item>
            </el-col>
          </el-row>
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
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  components: { MenuIcons, Treeselect },
  data() {
    return {
      menuData: [],
      menuTree: [],
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
            title: '排序',
            width: 60
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
        pid: [{ required: true, message: '请选择上级菜单', trigger: 'change' }],
        name: [{ required: true, message: '请输入菜单名称', trigger: 'change' }]
      },
      searchTimeout: ''
    }
  },
  mounted() {
    this.reloadTable()
  },
  watch: {
    'temp.type'(type) {
      for (var t in this.getTemp()) {
        if(t != 'type'){
          this.temp[t] = row[t]
        }
      }
      if(type == 'menu'){
        this.temp.isShow = 1
      }else{
        this.temp.isShow = 0
      }
    },
    menuData() {
      this.menuTree = [{
        label: '根节点',
        id: '0',
        children: this.genMenuTree(this.menuData)
      }]
    }
  },
  methods: {
    isChildren(children, id) {
      var result = false
      for(var i in children) {
        var chi = children[i]
        if(chi.id == id){
          result = true
        }
        if(chi.children && children.length > 0){
          if(this.isChildren(chi.children, id)){
            result = true
          }
        }
      }
      return result
    },
    queryChildren(children, id) {
      var result = []
      for(var i in children){
        var chi = children[i]
        if(chi.id == id){
          if(chi.children && chi.children.length > 0){
            result = chi.children
          }
        }else{
          var qc = this.queryChildren(chi.children, id)
          if(qc.length > 0){
            result = qc
          }
        }
      }
      return result
    },
    genMenuTree(children) {
      var menuTree = []
      for(var i in children){
        var chi = {}
        chi.label = children[i].name
        chi.id = children[i].id
        if(children[i].children && children[i].children.length > 0){
          chi.children = this.genMenuTree(children[i].children)
        }
        menuTree.push(chi)
      }
      return menuTree
    },
    searchMenu() {
      var _this = this
      clearTimeout(this.searchTimeout)
      this.searchTimeout = setTimeout(() => {
        if(_this.searchValue){
          _this.$set(_this.tableOptions, 'data', _this.recursionSearch(_this.$common.copyNew(_this.menuData), _this.searchValue))
        }else{
          _this.$set(_this.tableOptions, 'data', _this.menuData)
        }
      },1000)
    },
    recursionSearch(data, text){
      var searchData = []
      for(var i in data){
        var treeNode = data[i]
        var children = treeNode.children
        if(children && children.length > 0){
          var childrenSearch = this.recursionSearch(children, text)
          treeNode.children = childrenSearch && childrenSearch.length > 0 ? childrenSearch : treeNode.children
          this.treeNodeReplace(searchData, treeNode, text, childrenSearch)
        }else{
          this.treeNodeReplace(searchData, treeNode, text)
        }
      }
      return searchData
    },
    treeNodeReplace(searchData, treeNode, text, childrenSearch){
      var exist = false
      var fields = ['name', 'url', 'permission']
      fields.forEach((f) => {
        if(treeNode[f] && treeNode[f].indexOf(text) != -1){
          treeNode[f] = treeNode[f].replace(text, `<font color="#FAA353">${text}</font>`)
          exist = true
        }
      })
      if(exist || (childrenSearch && childrenSearch.length > 0)){
        searchData.push(treeNode)
      }
    },
    generateIconCode(symbol) {
      return `<svg style="width: 20px;height: 20px;fill: #999" aria-hidden="true" class="svg-icon disabled"><use href="#icon-${symbol}"></use></svg>`
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
        isShow: 1,
        pid: '',
        icon: '',
        type: 'menu',
        keepAlive: 1
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
          if(this.temp.pid == this.temp.id){
            this.$notify({
              title: '失败',
              message: '上级菜单不能选当前菜单',
              type: 'error',
              duration: 2000
            })
            return
          }
          if(this.isChildren(this.queryChildren(this.menuData, this.temp.id), this.temp.pid)){
            this.$notify({
              title: '失败',
              message: '上级菜单不能选当前菜单子级',
              type: 'error',
              duration: 2000
            })
            return
          }
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
      this.$get('menu/tree').then(res => {
        this.menuData = res.data.list
        this.$set(this.tableOptions, 'data', this.menuData)
      })
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      this.temp.type = this.temp.url ? 'menu' : 'button'
      this.temp.name = this.temp.name.replaceAll(/<font.*?>(.*?)<\/font>/g,'$1')
      this.dialogStatus = 'update'
      this.$refs.menuFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}

</script>

<style>
.el-input-number .el-input__inner{
  text-align: left;
}
</style>

<template>
  <div>
    <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px" style="width: 900px; margin-left:50px;">
      <el-row :gutter="24">
        <el-col :span="12">
          <el-form-item label="菜单类型" prop="type">
            <el-radio-group v-model="menuType" size="small">
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
      <el-form-item label="菜单链接" prop="url" v-if="menuType == 'menu'">
        <el-input v-model="temp.url" />
      </el-form-item>
      <el-form-item label="权限标识" prop="permission" v-if="menuType == 'button'">
        <el-input v-model="temp.permission" />
      </el-form-item>
      <el-row :gutter="24">
        <el-col :span="6">
          <el-form-item label="排序" prop="sort">
            <el-input-number v-model="temp.sort" controls-position="right" />
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="选择图标" prop="icon" v-if="menuType == 'menu'">
            <a @click="openIcons">
              <el-input v-model="temp.icon" class="input-with-select">
                <el-button class="icon-btn" slot="append">
                  <i v-html="generateIconCode(temp.icon)"></i>
                </el-button>
              </el-input>
            </a>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="菜单显示" v-if="menuType == 'menu'">
            <el-radio-group v-model="temp.isShow" size="small">
              <el-radio-button label="1">显示</el-radio-button>
              <el-radio-button label="0">不显示</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="路由缓存" v-if="menuType == 'menu'">
            <el-radio-group v-model="temp.keepAlive" size="small">
              <el-radio-button label="1">缓存</el-radio-button>
              <el-radio-button label="0">不缓存</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
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
  name: 'MenuForm',
  components: { MenuIcons, Treeselect },
  props: {
    menuTree: {
      type: Array,
      default: () => []
    }
  },
  data() {
    var validateUrl = (rule, value, callback) => {
      if(this.menuType == 'menu'){
        if(!value){
          callback(new Error('请输入菜单链接'))
        }else{
          callback()
        }
      }else{
        callback()
      }
    }
    var validatePermission = (rule, value, callback) => {
      if(this.menuType == 'button'){
        if(!value){
          callback(new Error('请输入权限标识'))
        }else{
          callback()
        }
      }else{
        callback()
      }
    }
    return {
      temp: this.getTemp(),
      menuType: 'menu',
      rules: {
        pid: [{ required: true, message: '请选择上级菜单', trigger: 'change' }],
        name: [{ required: true, message: '请输入菜单名称', trigger: 'change' }],
        url: [{ required: true, trigger: 'change', validator: validateUrl }],
        permission: [{ required: true, trigger: 'change', validator: validatePermission }]
      }
    }
  },
  watch: {
    menuType(type) {
      this.$nextTick(() => {
        this.$refs.dataForm.clearValidate()
      })
      if(type == 'menu'){
        this.temp.isShow = 1
      }else{
        this.temp.isShow = 0
      }
    }
  },
  methods: {
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
          if(this.$treeTable.isChildren(this.$treeTable.queryChildren(this.menuData, this.temp.id), this.temp.pid)){
            this.$notify({
              title: '失败',
              message: '上级菜单不能选当前菜单子级',
              type: 'error',
              duration: 2000
            })
            return
          }
          if(this.menuType == 'menu'){
            this.temp.permission = ''
          }else{
            this.temp.isShow = 0
            this.temp.keepAlive = 0
            this.temp.icon = ''
            this.temp.url = ''
          }
          this.$post('menu/save', this.temp).then(() => {
            this.$notify({
              title: '成功',
              message: (this.dialogStatus === 'create' ? '创建' : '修改') + '成功',
              type: 'success',
              duration: 2000
            })
            this.$emit('reload-table')
          })
        }
      })
    },
    addSubMenu(id) {
      this.resetTemp()
      this.menuType = 'menu'
      this.temp.pid = id
      this.temp.id = this.$common.uuid()
      this.getSort()
      this.$nextTick(() => {
        this.$refs.dataForm.clearValidate()
      })
    },
    getInfo(row) {
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      this.menuType = this.temp.url ? 'menu' : 'button'
      this.temp.name = this.temp.name.replaceAll(/<font.*?>(.*?)<\/font>/g,'$1')
      this.$nextTick(() => {
        this.$refs.dataForm.clearValidate()
      })
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
        keepAlive: 1
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    selectIcon(symbol) {
      this.$set(this.temp, 'icon', symbol)
      this.$refs.iconDialog.hide()
    },
    openIcons() {
      this.$refs.iconDialog.show()
    },
    getSort() {
      this.$get('menu/sort', { pid: this.temp.pid }).then(res => {
        this.temp.sort = res.data
      })
    },
    generateIconCode(symbol) {
      return `<svg style="width: 20px;height: 20px;fill: #999" aria-hidden="true" class="svg-icon disabled"><use href="#icon-${symbol}"></use></svg>`
    }
  }
}
</script>

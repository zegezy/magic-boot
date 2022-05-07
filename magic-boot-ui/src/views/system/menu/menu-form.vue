<style>
.el-input-number .el-input__inner{
  text-align: left;
}
</style>

<template>
  <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="菜单类型" prop="type">
          <el-radio-group v-model="menuType">
            <el-radio-button label="menu">菜单</el-radio-button>
            <el-radio-button label="button">按钮</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="上级菜单" prop="pid">
          <el-tree-select v-model="temp.pid" :data="menuTree" :key="temp.pid" style="width: 100%" check-strictly />
        </el-form-item>
      </el-col>
    </el-row>
    <el-form-item label="菜单名称" prop="name">
      <el-input v-model="temp.name" />
    </el-form-item>
    <el-form-item label="菜单链接" prop="url" v-if="menuType == 'menu'">
      <el-input v-model="temp.url" />
    </el-form-item>
    <el-form-item label="关联组件" prop="componentName" v-if="menuType == 'menu'">
      <el-tree-select v-model="temp.componentName" :data="componentTree" :key="temp.componentName" style="width: 100%" placeholder=" " />
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
              <template #append>
                <el-button style="height:32px;">
                  <mb-icon :icon="temp.icon" />
                </el-button>
              </template>
            </el-input>
          </a>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="菜单显示" v-if="menuType == 'menu'">
          <el-radio-group v-model="temp.isShow">
            <el-radio-button label="1">显示</el-radio-button>
            <el-radio-button label="0">不显示</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="路由缓存" v-if="menuType == 'menu'">
          <el-radio-group v-model="temp.keepAlive">
            <el-radio-button label="1">缓存</el-radio-button>
            <el-radio-button label="0">不缓存</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
  <mb-dialog ref="iconDialog">
    <template #content>
      <menu-icons :select-icon="selectIcon" />
    </template>
  </mb-dialog>
</template>

<script setup>
import { ref, reactive, watch, nextTick, getCurrentInstance, defineExpose } from 'vue'
import MenuIcons from './menu-icons'

const { proxy } = getCurrentInstance()

const props = defineProps({
  menuTree: {
    type: Array,
    default: () => []
  },
  menuData: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['reload-table'])
const componentTree = ref()
const dataForm = ref()
const iconDialog = ref()
const menuType = ref('menu')
const getTemp = () => {
  return {
    id: '',
    name: '',
    url: '',
    permission: '',
    sort: 0,
    descRibe: '',
    isShow: 1,
    pid: 0,
    icon: '',
    keepAlive: 0,
    componentName: ''
  }
}

proxy.$get('/system/component/select').then(res => {
  componentTree.value = res.data
})

const temp = ref(getTemp())

var validateUrl = (rule, value, callback) => {
  if(menuType.value == 'menu'){
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
  if(menuType.value == 'button'){
    if(!value){
      callback(new Error('请输入权限标识'))
    }else{
      callback()
    }
  }else{
    callback()
  }
}

const rules = reactive({
  pid: [{ required: true, message: '请选择上级菜单', trigger: 'change' }],
  name: [{ required: true, message: '请输入菜单名称', trigger: 'change' }],
  url: [{ required: true, trigger: 'change', validator: validateUrl }],
  permission: [{ required: true, trigger: 'change', validator: validatePermission }]
})

watch(menuType, (type) => {
  nextTick(() => {
    dataForm.value.clearValidate()
  })
  if(type == 'menu'){
    temp.value.isShow = 1
  }else{
    temp.value.isShow = 0
  }
})

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      if(temp.value.pid == temp.value.id){
        this.$notify({
          title: '失败',
          message: '上级菜单不能选当前菜单',
          type: 'error',
          duration: 2000
        })
        return
      }
      if(proxy.$treeTable.isChildren(proxy.$treeTable.queryChildren(props.menuData, temp.value.id), temp.value.pid)){
        proxy.$notify({
          title: '失败',
          message: '上级菜单不能选当前菜单子级',
          type: 'error',
          duration: 2000
        })
        return
      }
      if(menuType.value == 'menu'){
        temp.value.permission = ''
      }else{
        temp.value.isShow = 0
        temp.value.keepAlive = 0
        temp.value.icon = ''
        temp.value.url = ''
      }
      proxy.$post('/system/menu/save', temp.value).then(() => {
        d.hideLoading()
        proxy.$notify({
          title: '成功',
          message: d.title + '成功',
          type: 'success',
          duration: 2000
        })
        d.hide()
        emit('reload-table')
      }).catch(() => d.hideLoading())
    }
  })
}

function addSubMenu(id) {
  resetTemp()
  menuType.value = 'menu'
  temp.value.pid = id
  temp.value.id = proxy.$common.uuid()
  getSort()
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}
function getInfo(row) {
  for (var t in temp.value) {
    temp.value[t] = row[t]
  }
  menuType.value = temp.value.url ? 'menu' : 'button'
  temp.value.name = temp.value.name.replaceAll(/<font.*?>(.*?)<\/font>/g,'$1')
  nextTick(() => {
    dataForm.value.clearValidate()
  })
}

function resetTemp() {
  temp.value = getTemp()
}

function selectIcon(symbol) {
  temp.value.icon = symbol
  iconDialog.value.hide()
}

function openIcons() {
  iconDialog.value.show()
}

function getSort() {
  proxy.$get('/system/menu/sort', { pid: temp.value.pid }).then(res => {
    temp.value.sort = res.data
  })
}

defineExpose({ addSubMenu, getInfo, save })

</script>

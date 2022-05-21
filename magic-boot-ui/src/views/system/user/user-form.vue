<template>
  <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="90px" v-if="isForm">
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="登录名称" prop="username">
          <el-input v-model="temp.username" autocomplete="new-password" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="密码" prop="password">
          <el-input v-model="temp.password" type="password" autocomplete="new-password" />
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="姓名/昵称" prop="name">
          <el-input v-model="temp.name" autocomplete="new-password" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="temp.phone" />
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="组织机构" prop="officeId">
          <mb-treeselect url="/system/user/offices" v-model="temp.officeId" :key="temp.officeId" placeholder="请选择组织机构" check-strictly />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="选择角色" prop="roles">
          <mb-select v-model="temp.roles" url="/system/role/all" placeholder="请选择角色" multiple />
        </el-form-item>
      </el-col>
    </el-row>
    <el-form-item label="登录状态" prop="isLogin" v-if="temp.id != '1'">
      <el-radio-group v-model="temp.isLogin">
        <el-radio-button label="0">有效</el-radio-button>
        <el-radio-button label="1">锁定</el-radio-button>
      </el-radio-group>
    </el-form-item>
  </el-form>
</template>

<script setup>

import { ref, reactive, getCurrentInstance, nextTick } from 'vue'

const emit = defineEmits(['reload-table'])
const { proxy } = getCurrentInstance()

const rules = reactive({
  name: [{ required: true, message: '请输入姓名/昵称', trigger: 'change' }],
  username: [{ required: true, message: '请输入登录名称', trigger: 'change' }],
  roles: [{ required: true, message: '请选择角色', trigger: 'change' }],
  officeId: [{ required: true, message: '请选择组织机构', trigger: 'change' }]
})
const temp = ref(getTemp())
const isForm = ref(true)
const dataForm = ref()

function getTemp() {
  return {
    id: '',
    name: '',
    username: '',
    password: '',
    phone: '',
    isLogin: 0,
    roles: null,
    officeId: null
  }
}

function resetTemp() {
  isForm.value = false
  rules.password = [{ required: true, message: '请输入密码', trigger: 'change' }]
  temp.value = getTemp()
  nextTick(() => {
    isForm.value = true
    nextTick(() => {
      dataForm.value.clearValidate()
    })
  })
}

function save(d) {
  dataForm.value.validate((valid) => {
    if (valid) {
      d.loading()
      proxy.$post('/system/user/save', temp.value).then(() => {
        d.hideLoading()
        proxy.$notify({
          title: '成功',
          message: d.title + '成功',
          type: 'success',
          duration: 2000
        })
        emit('reload-table')
      }).catch(() => d.hideLoading())
    }
  })
}

function getInfo(row) {
  isForm.value = false
  delete rules.password
  nextTick(() => {
    isForm.value = true
  })
  for (var t in temp.value) {
    if (t !== 'roles') {
      temp.value[t] = row[t]
    }
  }
  proxy.$get('/system/user/roles', { userId: temp.value.id }).then((res) => {
    temp.value.roles = res.data.join(',')
  })
}

defineExpose({ save, getInfo, resetTemp })

</script>

<template>
  <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="120px" style="width: 400px; margin-left:50px;">
    <el-form-item label="登录名称" prop="username">
      <el-input v-model="temp.username" />
    </el-form-item>
    <el-form-item label="姓名/昵称" prop="name">
      <el-input v-model="temp.name" />
    </el-form-item>
    <el-form-item label="密码" prop="password">
      <el-input v-model="temp.password" />
    </el-form-item>
    <el-form-item label="手机号" prop="phone">
      <el-input v-model="temp.phone" />
    </el-form-item>
    <el-form-item label="禁止登录" prop="isLogin">
      <template>
        <el-switch
          v-model="temp.isLogin"
          :active-value="1"
          :inactive-value="0"
        />
      </template>
    </el-form-item>
    <el-form-item label="选择角色">
      <el-checkbox-group v-model="selectRoles" size="small">
        <el-checkbox v-for="role in roles" :key="role.id" :label="role.id">{{ role.name }}</el-checkbox>
      </el-checkbox-group>
    </el-form-item>
  </el-form>
</template>

<script>

export default {
  name: 'UserForm',
  props: {
    dialogStatus: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      rules: {
        username: [{ required: true, message: '请输入登录名称', trigger: 'change' }]
      },
      roles: [],
      selectRoles: [],
      temp: this.getTemp()
    }
  },
  created() {
    this.$get('role/list?size=999999').then(response => {
      const { data } = response
      this.roles = data.list
    })
  },
  methods: {
    getTemp() {
      return {
        id: '',
        name: '',
        username: '',
        password: '',
        phone: '',
        isLogin: 0,
        roles: []
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.temp.roles = this.selectRoles.join(',')
          this.$request({
            url: 'user/save',
            method: 'post',
            params: this.temp
          }).then((response) => {
            this.dialogVisible = false
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
    getInfo(row) {
      for (var t in this.temp) {
        if (t !== 'roles') {
          this.temp[t] = row[t]
        }
      }
      this.$get('user/roles', { userId: this.temp.id }).then((response) => {
        const { data } = response
        this.selectRoles = data
      })
    }
  }
}
</script>

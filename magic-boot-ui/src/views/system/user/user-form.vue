<template>
  <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px">
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="登录名称" prop="username">
          <el-input v-model="temp.username" autocomplete="new-password" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="姓名/昵称" prop="name">
          <el-input v-model="temp.name" autocomplete="new-password" />
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="24">
      <el-col :span="12">
        <el-form-item label="密码" prop="password">
          <el-input v-model="temp.password" type="password" autocomplete="new-password" />
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
          <treeselect v-model="temp.officeId" :options="officeTree" :show-count="true" placeholder="请选择组织机构" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="选择角色" prop="roles">
          <mb-select v-model="temp.roles" url="role/list?size=999999" placeholder="请选择角色" labelField="name" valueField="id" :el="{ multiple: true }" />
        </el-form-item>
      </el-col>
    </el-row>
    <el-form-item label="登录状态" prop="isLogin">
      <el-radio-group v-model="temp.isLogin" size="small">
        <el-radio-button label="0">有效</el-radio-button>
        <el-radio-button label="1">锁定</el-radio-button>
      </el-radio-group>
    </el-form-item>
  </el-form>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  name: 'UserForm',
  components: { Treeselect },
  props: {
    dialogTitle: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      rules: {
        username: [{ required: true, message: '请输入登录名称', trigger: 'change' }],
        roles: [{ required: true, message: '请选择角色', trigger: 'change' }],
        officeId: [{ required: true, message: '请选择组织机构', trigger: 'change' }]
      },
      temp: this.getTemp(),
      officeTree: []
    }
  },
  created() {
    this.$get('user/offices').then(res => {
      this.officeTree = res.data.list
      this.$treeTable.deleteEmptyChildren(this.officeTree)
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
        roles: null,
        officeId: null
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
          this.$request({
            url: 'user/save',
            method: 'post',
            params: this.temp
          }).then((response) => {
            this.dialogVisible = false
            this.$notify({
              title: '成功',
              message: this.dialogTitle + '成功',
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
        this.temp.roles = data.join(',')
      })
    }
  }
}
</script>

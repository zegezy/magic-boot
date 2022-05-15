<template>
  <mb-form ref="magicForm" v-bind="formOptions" />
  <el-button @click="getFormData">获取表单数据</el-button>
</template>

<script setup>
import { ref, reactive, getCurrentInstance } from 'vue'
const { proxy } = getCurrentInstance()
const magicForm = ref()
const formOptions = reactive({
  form: {
    request: {
      url: "user/save",
      method: "post"
    },
    rows: [{
      gutter: 24,
      cols: [{
        span: 12,
        name: 'input',
        label: 'input',
        rules: [{ required: true, message: '请输入input', trigger: 'change' }]
      },{
        span: 12,
        name: 'switch',
        component: 'switch',
        label: 'switch',
        props: {
          activeValue: '1',
          inactiveValue: '0'
        }
      },{
        span: 12,
        name: 'checkbox',
        component: 'checkbox-group',
        label: 'checkbox',
        props: {
          type: 'office_type'
        }
      },{
        span: 12,
        name: 'checkboxButton',
        component: 'checkbox-group',
        label: 'checkboxButton',
        props: {
          type: 'office_type',
          button: true
        }
      },{
        span: 12,
        name: 'radio',
        component: 'radio-group',
        label: 'radio',
        props: {
          type: 'is_login'
        }
      },{
        span: 12,
        name: 'radioButton',
        component: 'radio-group',
        label: 'radioButton',
        props: {
          type: 'is_login',
          button: true
        }
      },{
        span: 12,
        name: 'date',
        component: 'date',
        label: 'date',
        props: {
          type: 'date'
        }
      },{
        span: 12,
        name: 'datetime',
        component: 'date',
        label: 'datetime',
        props: {
          type: 'datetime',
          format: 'YYYY-MM-DD HH:mm:ss'
        }
      },{
        span: 12,
        name: 'daterange',
        component: 'date',
        label: 'daterange',
        props: {
          type: 'daterange'
        }
      },{
        span: 12,
        name: 'datetimerange',
        component: 'date',
        label: 'datetimerange',
        props: {
          type: 'datetimerange',
          format: 'YYYY-MM-DD HH:mm:ss'
        }
      },{
        component: 'treeselect',
        span: 12,
        name: 'treeselect',
        label: 'treeselect',
        rules: [{ required: true, message: '请选择组织机构', trigger: 'change' }],
        props: {
          url: '/system/user/offices'
        }
      }, {
        component: 'select',
        span: 12,
        name: 'select',
        label: 'select',
        rules: [{ required: true, message: '请选择角色', trigger: 'change' }],
        props: {
          url: '/system/role/all',
          placeholder: '请选择角色',
          multiple: true
        }
      },{
        span: 12,
        name: 'head',
        component: 'upload-image',
        label: '头像',
        rules: [{ required: true, message: '请选择头像', trigger: 'change' }]
      },{
        span: 12,
        name: 'heads',
        component: 'upload-image',
        label: '多头像',
        props: {
          multiple: true
        },
        rules: [{ required: true, message: '请选择头像', trigger: 'change' }]
      }]
    }]
  }
})
function getFormData(){
  console.log(magicForm.value.getFormData())
}
</script>

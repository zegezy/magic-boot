<template>
  <mb-list ref="magicList" v-bind="listOptions" />
  <mb-dialog ref="formDialog" @confirm-click="magicForm.save($event)" width="50%">
    <template #content>
      <mb-form ref="magicForm" @reload="magicList.reload" v-bind="formOptions" />
    </template>
  </mb-dialog>
</template>

<script setup>
import { ref, reactive, getCurrentInstance } from 'vue'
const { proxy } = getCurrentInstance()
const formDialog = ref()
const magicList = ref()
const magicForm = ref()
const listOptions = reactive({
  search: {
    noReset: 'id'
  },
  tools: [{
    type: 'add',
    permission: 'user:save',
    click: () => {
      formOptions.form.rows[0].cols[1].rules = [{ required: true, message: '请输入密码', trigger: 'change' }]
      formOptions.detail.formData = null
      formDialog.value.show()
    }
  },{
    type: 'delete',
    permission: 'user:delete',
    url: '/system/user/delete'
  }],
  table: {
    url: '/system/user/list',
    where: {
      username: {
        label: '登录名称',
      },
      name: {
        label: '姓名/昵称',
      },
      roleId: {
        type: 'select',
        label: '角色',
        props: {
          url: '/system/role/all',
          multiple: true
        }
      }
    },
    cols: [
      {
        field: 'username',
        label: '登录名称',
        sortable: 'custom'
      }, {
        field: 'name',
        label: '姓名/昵称',
        sortable: 'custom'
      }, {
        field: 'officeName',
        label: '所属机构'
      }, {
        field: 'roles',
        label: '角色'
      }, {
        field: 'phone',
        label: '手机号',
        sortable: 'custom'
      }, {
        field: 'isLogin',
        label: '禁止登录',
        type: 'switch',
        width: 100,
        change: (row) => {
          proxy.$get('/system/user/change/login/status', {
            id: row.id,
            isLogin: row.isLogin
          })
        }
      }, {
        field: 'createDate',
        label: '创建时间',
        width: 180
      }, {
        label: '操作',
        type: 'btns',
        width: 140,
        fixed: 'right',
        btns: [
          {
            permission: 'user:save',
            label: '修改',
            type: 'text',
            icon: 'ElIconEdit',
            click: (row) => {
              // magicForm.value.getDetail(row.id)
              formOptions.form.rows[0].cols[1].rules = []
              formOptions.detail.formData = proxy.$common.copyNew(row)
              formDialog.value.show()
            }
          }, {
            permission: 'user:delete',
            label: '删除',
            type: 'text',
            icon: 'ElIconDelete',
            click: (row) => {
              proxy.$common.handleDelete({
                url: '/system/user/delete',
                id: row.id,
                done: () => magicList.value.reload()
              })
            }
          }
        ]
      }
    ]
  }
})
const formOptions = reactive({
  detail: {
    request: {
      url: '/system/user/get'
    }
  },
  form: {
    request: {
      url: "user/save",
      method: "post"
    },
    rows: [{
      gutter: 24,
      cols: [{
        span: 12,
        name: 'head',
        component: 'upload-image',
        label: '头像',
        rules: [{ required: true, message: '请选择头像', trigger: 'change' }]
      },{
        span: 12,
        name: 'username',
        label: '登录名称',
        rules: [{ required: true, message: '请输入登录名称', trigger: 'change' }]
      }, {
        span: 12,
        name: 'password',
        label: '密码'
      }]
    },{
      gutter: 24,
      cols: [{
        span: 12,
        name: 'name',
        label: '姓名/昵称'
      }, {
        span: 12,
        name: 'phone',
        label: '手机号'
      }]
    },{
      gutter: 24,
      cols: [{
        component: 'treeselect',
        span: 12,
        name: 'officeId',
        label: '组织机构',
        rules: [{ required: true, message: '请选择组织机构', trigger: 'change' }],
        props: {
          url: '/system/user/offices'
        }
      }, {
        component: 'select',
        span: 12,
        name: 'roles',
        label: '选择角色',
        rules: [{ required: true, message: '请选择角色', trigger: 'change' }],
        props: {
          url: '/system/role/all',
          placeholder: '请选择角色',
          multiple: true
        }
      }]
    }, {
      gutter: 24,
      cols: [{
        span: 24,
        component: 'radio-group',
        name: 'isLogin',
        label: '登录状态',
        defaultValue: '0',
        props: {
          button: true,
          options: [{
            label: '有效',
            value: '0'
          }, {
            label: '锁定',
            value: '1'
          }]
        }
      }]
    }]
  }
})
</script>

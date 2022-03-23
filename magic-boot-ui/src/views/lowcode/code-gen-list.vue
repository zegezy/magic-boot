<template>
  <mb-list ref="magicList" v-bind="listOptions" />
  <mb-dialog ref="formDialog" title="配置" @confirm-click="magicForm.save($event)" width="50%">
    <template #content>
      <code-gen-form />
    </template>
  </mb-dialog>
</template>

<script setup>
  import codeGenForm from './code-gen-form.vue'
  import { ref, reactive, getCurrentInstance } from 'vue'
  const { proxy } = getCurrentInstance()
  const formDialog = ref()
  const magicList = ref()
  const magicForm = ref()
  const listOptions = reactive({
    tools: [{
      type: 'add',
      permission: 'code:gen:save',
      click: () => {
        formDialog.value.show()
      }
    }],
    table: {
      url: 'code/gen/list',
      cols: [
        {
          field: 'tableName',
          label: '表名'
        },{
          field: 'tableComment',
          label: '描述'
        }, {
          label: '操作',
          type: 'btns',
          width: 140,
          fixed: 'right',
          btns: [
            {
              permission: 'code:gen:save',
              label: '修改',
              type: 'text',
              icon: 'ElEdit',
              click: (row) => {
                formDialog.value.show()
              }
            }, {
              permission: 'code:gen:delete',
              label: '删除',
              type: 'text',
              icon: 'ElDelete',
              click: (row) => {
                // proxy.$common.handleDelete({
                //   url: 'user/delete',
                //   id: row.id,
                //   done: () => magicList.value.reload()
                // })
              }
            }
          ]
        }
      ]
    }
  })
</script>

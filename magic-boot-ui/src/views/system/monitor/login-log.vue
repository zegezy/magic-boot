<template>
  <div class="app-container">
    <mb-search :where="tableOptions.where" @search="reloadTable" />
    <mb-table ref="table" v-bind="tableOptions" />
  </div>
</template>

<script setup>
  import { ref, reactive } from 'vue'
  const table = ref()
  const tableOptions = reactive({
    url: 'log/login/list',
    where: {
      createDate: {
        type: 'datetimerange',
        label: '创建时间',
        value: ''
      }
    },
    cols: [
      {
        field: 'username',
        label: '登录名'
      },
      {
        field: 'failPassword',
        label: '失败密码'
      },
      {
        field: 'type',
        label: '登录状态',
        templet: (row) => {
          return row.type == '成功' ? '<b style="color: #409EFF">成功</b>' : '<b style="color: red">失败</b>'
        }
      },
      {
        field: 'ip',
        label: 'ip'
      },
      {
        field: 'browser',
        label: '浏览器'
      },
      {
        field: 'os',
        label: '系统',
        props: {
          "show-overflow-tooltip": true
        }
      },
      {
        field: 'createDate',
        label: '操作时间'
      }
    ]
  })
  function reloadTable(){
    table.value.reloadList()
  }
</script>

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
    url: 'log/oper/list',
    where: {
      createDate: {
        type: 'datetimerange',
        label: '创建时间',
        value: ''
      }
    },
    cols: [
      {
        field: 'apiName',
        label: '接口名'
      },
      {
        field: 'apiPath',
        label: '路径'
      },
      {
        field: 'apiMethod',
        label: '方法'
      },
      {
        field: 'userIp',
        label: 'ip'
      },
      {
        field: 'costTime',
        label: '耗时'
      },
      {
        field: 'userAgent',
        label: '用户代理'
      },
      {
        field: 'username',
        label: '操作人'
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

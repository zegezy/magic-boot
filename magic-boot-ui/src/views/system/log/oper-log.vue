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
        title: '接口名'
      },
      {
        field: 'apiPath',
        title: '路径'
      },
      {
        field: 'apiMethod',
        title: '方法'
      },
      {
        field: 'userIp',
        title: 'ip'
      },
      {
        field: 'costTime',
        title: '耗时'
      },
      {
        field: 'userAgent',
        title: '用户代理'
      },
      {
        field: 'username',
        title: '操作人'
      },
      {
        field: 'createDate',
        title: '操作时间'
      }
    ]
  })
  function reloadTable(){
    table.value.reloadList()
  }
</script>

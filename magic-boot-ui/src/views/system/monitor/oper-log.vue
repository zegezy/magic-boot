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
        label: '方法',
        width: '100px'
      },
      {
        field: 'userIp',
        label: 'ip',
        width: '150px'
      },
      {
        field: 'costTime',
        label: '耗时',
        width: '100px'
      },
      {
        field: 'userAgent',
        label: '用户代理',
        props: {
          "show-overflow-tooltip": true
        }
      },
      {
        field: 'username',
        label: '操作人',
        width: '150px'
      },
      {
        field: 'createDate',
        label: '操作时间',
        width: '180px'
      }
    ]
  })
  function reloadTable(){
    table.value.reloadList()
  }
</script>

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
        title: '登录名'
      },
      {
        field: 'failPassword',
        title: '失败密码'
      },
      {
        field: 'type',
        title: '登录状态'
      },
      {
        field: 'ip',
        title: 'ip'
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

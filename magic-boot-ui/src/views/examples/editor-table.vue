<template>
  <div style="padding: 50px;">
    <el-button type="primary" @click="getData" style="margin-bottom: 10px">获取数据</el-button>
    <pd-editor-table v-model="tableDatas" :cols="cols" :show-no="false" />
  </div>
</template>

<script>

export default {
  name: 'EditorTable',
  data() {
    return {
      tableDatas: [],
      cols: [{
        type: 'input',
        field: 'name',
        title: '名称'
      }, {
        type: 'select',
        field: 'role',
        title: '角色',
        properties: {
          type: 'dict_type'
        }
      }]
    }
  },
  methods: {
    getData() {
      console.log(this.tableDatas)
    }
  }
}
</script>

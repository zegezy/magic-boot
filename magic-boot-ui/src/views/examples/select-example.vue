<template>
  <div style="padding: 50px;">
    <h2>多选</h2>
    <el-button type="primary" @click="getData" style="margin-bottom: 10px">获取数据</el-button>
    <mb-select v-model="dictType" type="dict_type" :el="{ multiple: true }" />
  </div>
</template>

<script>

export default {
  name: 'SelectExample',
  data() {
    return {
      dictType: '0,1'
    }
  },
  methods: {
    getData() {
      console.log(this.dictType)
    }
  }
}
</script>

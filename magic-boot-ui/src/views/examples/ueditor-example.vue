<template>
  <div>
    <mb-ueditor v-model="content" />
    <button @click="getContent">获取内容</button>
  </div>
</template>

<script>

export default {
  name: 'UeditorExample',
  data() {
    return {
      content: '默认content'
    }
  },
  methods: {
    getContent() {
      console.log(this.content)
    }
  }
}
</script>

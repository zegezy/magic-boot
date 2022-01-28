<template>
  <vue-ueditor-wrap v-model="content" :config="editorConfig" editor-id="mb-ueditor" />
</template>

<script>
import VueUeditorWrap from 'vue-ueditor-wrap'

export default {
  name: 'MbUeditor',
  components: {
    VueUeditorWrap
  },
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: {
      type: String,
      default: ''
    },
    config: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      content: '',
      editorConfig: {}
    }
  },
  watch: {
    content(value) {
      this.$emit('change', value)
    },
    value(value) {
      this.content = value
    }
  },
  created() {
    this.content = this.value
    this.editorConfig = this.config || {}
    this.editorConfig.UEDITOR_HOME_URL = this.editorConfig.UEDITOR_HOME_URL || '/UEditor/'
    this.editorConfig.serverUrl = this.editorConfig.serverUrl || process.env.VUE_APP_BASE_API + 'ueditor/main'
  }
}

</script>

<template>
  <vue-ueditor-wrap v-model="content" :config="editorConfig" editor-id="mb-ueditor" />
</template>

<script>

export default {
  name: 'MbUeditor',
  emits: ['change', 'update:modelValue'],
  model: {
    prop: 'modelValue',
    event: 'change'
  },
  props: {
    modelValue: {
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
      this.$emit('update:modelValue', value)
      this.$emit('change', value)
    },
    modelValue(value) {
      this.content = value
    }
  },
  created() {
    this.content = this.value
    this.editorConfig = this.config || {}
    this.editorConfig.UEDITOR_HOME_URL = this.editorConfig.UEDITOR_HOME_URL || '/UEditor/'
    this.editorConfig.serverUrl = this.editorConfig.serverUrl || import.meta.env.VITE_APP_BASE_API + 'ueditor/main'
  }
}

</script>

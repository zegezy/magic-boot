<template>
  <div ref="jsoneditor" style="height: 800px" />
</template>

<script>
import JSONEditor from 'jsoneditor/dist/jsoneditor.js'
import 'jsoneditor/dist/jsoneditor.css'

export default {
  name: 'JsonEditor',
  props: {
    json: {
      type: Object,
      default: () => {}
    },
    options: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      editor: null
    }
  },
  watch: {
    json(newJson) {
      if (this.editor) {
        this.editor.destroy()
        this.editor = new JSONEditor(this.$refs.jsoneditor, this.options, newJson)
      }
    }
  },
  mounted() {
    this.editor = new JSONEditor(this.$refs.jsoneditor, this.options, this.json)
  }
}
</script>

<style>
</style>

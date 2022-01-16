<template>
  <el-dialog v-el-drag-dialog :fullscreen="fullscreen" :width="width" :title="title" :visible.sync="dialogVisible" :close-on-click-modal="false" :append-to-body="true" @opened="opened">
    <template v-if="content">
      {{ content }}
    </template>
    <slot v-else name="content" />
    <div slot="footer" class="dialog-footer">
      <el-button @click="dialogVisible = false">
        关闭
      </el-button>
      <el-button type="primary" @click="confirmClick">
        确认
      </el-button>
    </div>
  </el-dialog>
</template>

<script>
export default {
  name: 'PdDialog',
  props: {
    title: {
      type: String,
      default: ''
    },
    content: {
      type: String,
      default: '',
      require: false
    },
    width: {
      type: String,
      default: '50%'
    },
    fullscreen: {
      type: Boolean,
      default: false
    },
    opened: {
      type: Function,
      default: () => {}
    }
  },
  data() {
    return {
      dialogVisible: false
    }
  },
  created() {
    if (this.fullscreen) {
      document.body.style.setProperty('--el-dialog__wrapper-bottom', '0vh')
      document.body.style.setProperty('--el-dialog__wrapper-top', '0vh')
      document.body.style.setProperty('--el-dialog__body-max-height', '100vh')
    } else {
      document.body.style.setProperty('--el-dialog__wrapper-bottom', '15vh')
      document.body.style.setProperty('--el-dialog__wrapper-top', '15vh')
      document.body.style.setProperty('--el-dialog__body-max-height', '60vh')
    }
  },
  methods: {
    confirmClick() {
      this.$emit('confirm-click')
    },
    show() {
      this.dialogVisible = true
    },
    hide() {
      this.dialogVisible = false
    }
  }
}
</script>

<style scoped>

.el-dialog__wrapper{
  padding-bottom: var(--el-dialog__wrapper-bottom);
  padding-top: var(--el-dialog__wrapper-top);
  overflow: hidden;
}
.el-dialog__wrapper >>> .el-dialog{
  margin-top: 0vh!important;
}
.el-dialog__wrapper >>> .el-dialog__body{
  max-height: var(--el-dialog__body-max-height);
  overflow: auto;
  padding: 25px!important;
}

</style>

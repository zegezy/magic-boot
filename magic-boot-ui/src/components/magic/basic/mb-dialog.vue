<template>
  <el-dialog :fullscreen="fullscreen" :width="width" :title="title" v-model="dialogVisible" :close-on-click-modal="false" :key="dialogKey" :append-to-body="true" draggable @opened="opened">
    <slot name="content" />
    <template #footer>
      <div slot="footer" class="dialog-footer">
        <slot name="btns">
          <el-button @click="dialogVisible = false">
            关闭
          </el-button>
          <el-button type="primary" :loading="confirmLoading" @click="confirmClick">
            确认
          </el-button>
        </slot>
      </div>
    </template>
  </el-dialog>
</template>

<script>

export default {
  emits: ['confirm-click'],
  props: {
    title: {
      type: String,
      default: ''
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
    },
    autoKey: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      dialogVisible: false,
      confirmLoading: false,
      dialogKey: 'mbDialog',
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
      this.$emit('confirm-click', this)
    },
    loading(){
      this.confirmLoading = true
    },
    hideLoading(){
      this.confirmLoading = false
    },
    show() {
      if(this.autoKey){
        this.dialogKey = Math.random()
      }
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

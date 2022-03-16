<template>
  <el-dialog
    v-model="dialogVisible"
    :custom-class="customClass"
    :fullscreen="fullscreen"
    :width="width"
    :title="title"
    :close-on-click-modal="false"
    :destroy-on-close="destroyOnClose"
    :append-to-body="true"
    draggable
    @open="$emit('open')"
    @close="$emit('close')"
  >
    <slot name="content" />
    <template #footer>
      <div slot="footer" class="dialog-footer">
        <slot name="btns">
          <el-button @click="hide">
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
  emits: ['confirm-click', 'open', 'close'],
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
    destroyOnClose: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      dialogVisible: false,
      confirmLoading: false,
      customClass: 'mbDialog' + this.$common.uuid()
    }
  },
  watch: {
    dialogVisible(value) {
      if(value){
        this.addStyle()
      }else{
        this.removeStyle()
      }
    }
  },
  created() {
    this.addStyle()
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
      this.dialogVisible = true
    },
    hide() {
      this.dialogVisible = false
    },
    addStyle(){
      var componentStyle = document.createElement("style");
      var cc = this.customClass
      if (this.fullscreen) {
        componentStyle.innerHTML = `
        .${cc}{
          margin-top: 0vh;
          margin-bottom: 0vh;
        }
        .${cc} .el-dialog__body{
          max-height: 100vh;
        }
      `
      } else {
        componentStyle.innerHTML = `
        .${cc}{
          margin-top: 10vh;
          margin-bottom: 10vh;
        }
        .${cc} .el-dialog__body{
          max-height: 60vh;
          overflow: auto;
        }
      `
      }
      componentStyle.id = cc
      document.head.appendChild(componentStyle);
    },
    removeStyle(){
      document.getElementById(this.customClass) && document.getElementById(this.customClass).remove()
    }
  }
}

</script>

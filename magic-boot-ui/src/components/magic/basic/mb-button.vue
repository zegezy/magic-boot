<template>
  <el-button
    v-bind="el_"
    @click="buttonClick"
  >
    {{ el_.text }}
  </el-button>
</template>

<script>
import { getToken } from '@/scripts/auth'
import {ElNotification} from "element-plus";

export default {
  name: 'MbButton',
  props: {
    el: {
      type: Object,
      default: () => {}
    },
    btnType: {
      type: String,
      default: ''
    },
    requestMethod: {
      type: String,
      default: 'get'
    },
    requestUrl: {
      type: String,
      default: ''
    },
    requestData: {
      type: Object,
      default: () => {}
    },
    beforeConfirm: {
      type: String,
      default: ''
    },
    successTips: {
      type: String,
      default: ''
    },
    failTips: {
      type: String,
      default: ''
    },
    confirmType: {
      type: String,
      default: 'warning'
    },
    afterHandler: {
      type: Function,
      default: () => {}
    },
    isOpen: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      el_: this.el || {},
      requestMethod_: this.requestMethod,
      beforeConfirm_: this.beforeConfirm,
      successTips_: this.successTips,
      failTips_: this.failTips
    }
  },
  created() {
    if (this.btnType) {
      if (this.btnType === 'delete') {
        this.requestMethod_ = 'delete'
        this.el_.type = 'danger'
        this.el_.text = '删除'
        this.el_.icon = 'ElIconDelete'
        this.beforeConfirm_ = '此操作将永久删除该数据, 是否继续?'
        this.successTips_ = '删除成功！'
        this.failTips_ = '删除失败！'
      }
    }
  },
  methods: {
    async buttonClick() {
      if (this.beforeConfirm_) {
        this.$confirm(this.beforeConfirm_, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: this.confirmType
        }).then((res) => {
          this.buttonClickRequest().then(() => {
            this.afterHandler()
          })
        })
      }
    },
    buttonClickRequest() {
      // var requestOptions = {}
      // requestOptions.url = this.requestUrl
      // requestOptions.method = this.requestMethod_
      // if (requestOptions.method === 'get') {
      //   requestOptions.params = this.requestData
      // } else {
      //   requestOptions.data = this.requestData
      // }
      if (this.isOpen) {
        return new Promise(() => {
          window.open(this.$common.getUrl(process.env.VUE_APP_BASE_API + this.requestUrl, this.requestData) + '&token=' + getToken())
        })
      }
      return new Promise((resolve, reject) => {
        this.$request({
          url: this.requestUrl,
          method: this.requestMethod_,
          params: this.requestData,
          data: this.requestData
        }).then(res => {
          const { data } = res
          if (data) {
            ElNotification({
              title: '成功',
              message: this.successTips_,
              type: 'success',
              duration: 2000
            })
          } else {
            this.$message.error(this.failTips_)
          }
          resolve()
        })
      })
    }
  }
}
</script>

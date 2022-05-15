<template>
  <el-upload
    :id="uploadDomId"
    class="upload-demo"
    ref="uploadRef"
    :action="actionUrl"
    :headers="headers"
    :on-preview="handlePreview"
    :on-remove="handleRemove"
    :before-remove="beforeRemove"
    :multiple="multiple"
    :limit="limit"
    :on-exceed="handleExceed"
    v-bind="uploadDynamicProps"
    :show-file-list="showFileList"
    :before-upload="beforeAvatarUpload"
    :on-success="handleAvatarSuccess"
  >
    <el-button type="primary" icon="ElIconUploadFilled" :loading="uploadLoading" :disabled="!multiple && fileList.length == 1">{{ label }}</el-button>
    <div slot="tip" v-if="showTip" class="el-upload__tip">支持上传{{ getSettingSuffixs().replaceAll(',', '，') }}文件，且不超过{{ maxFileSize }}MB</div>
  </el-upload>
</template>

<script>
import { getToken } from '@/scripts/auth'
export default {
  name: 'MbUploadFile',
  emits: ['change', 'update:modelValue'],
  model: {
    prop: 'modelValue',
    event: 'change'
  },
  props: {
    modelValue: {
      required: false
    },
    multiple: {
      type: Boolean,
      default: false
    },
    limit: {
      type: Number,
      default: 20
    },
    maxFileSize: {
      type: Number,
      default: 200
    },
    accept: {
      type: String,
      default: ''
    },
    externalId: {
      type: String,
      default: ''
    },
    externalType: {
      type: String,
      default: ''
    },
    formats: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: '点击上传'
    },
    showTip: {
      type: Boolean,
      default: () => true
    },
    action: {
      type: String,
      default: ''
    },
    showFileList: {
      type: Boolean,
      default: () => true
    },
    onSuccess: {
      type: Function,
      default: () => {}
    },
    showRemoveTip: {
      type: Boolean,
      default: () => true
    },
    join: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      acceptList: {
        image: 'png,jpg,gif,jpeg',
        wps: 'pdf,pptx,xls,xlsx,csv,docx,doc',
        compress: 'zip,rar,7z',
        video: 'avi,flv,mp4,mpeg,mov'
      },
      imageUrl: '',
      actionUrl: import.meta.env.VITE_APP_BASE_API + '/system/file/upload',
      headers: {
        token: getToken()
      },
      urls: [],
      uploadDomId: Math.random(),
      fileList: [],
      uploadLoading: false,
      uploadDynamicProps: {}
    }
  },
  watch: {
    modelValue(newValue) {
      this.renderFile()
    }
  },
  created() {
    if (this.externalId) {
      this.$get('/system/file/files', { externalId: this.externalId, externalType: this.externalType }).then(res => {
        const { data } = res
        this.fileList = data
      })
      this.actionUrl = this.actionUrl + `?externalId=${this.externalId}&externalType=${this.externalType}`
    } else {
      this.renderFile()
    }
    // 解决多文件上传时，第一次上传的多个的时候 只能有一个成功的bug
    if (this.modelValue instanceof Array && this.modelValue.length > 0) {
      this.uploadDynamicProps.fileList = this.fileList
    } else {
      if (this.modelValue) {
        this.uploadDynamicProps.fileList = this.fileList
      }
    }
    if(this.action){
      this.actionUrl = import.meta.env.VITE_APP_BASE_API + this.action
    }
  },
  methods: {
    handlerRemove(file){
      this.$refs.uploadRef.handleRemove(file)
    },
    renderFile() {
      if (this.modelValue instanceof Array && this.modelValue.length > 0) {
        this.fileList = this.modelValue.map(it => {
          return {
            name: it.substring(it.lastIndexOf('/') + 1),
            response: {
              data: {
                url: it
              }
            }
          }
        })
      } else {
        if (this.modelValue) {
          this.fileList.push({
            name: this.modelValue.substring(this.modelValue.lastIndexOf('/') + 1),
            response: {
              data: {
                url: this.modelValue
              }
            }
          })
        }
      }
    },
    handleRemove(file, fileList) {
      var url = file.response.data.url
      this.urls.splice(this.urls.indexOf(url), 1)
      this.fileList.forEach((it, i) => {
        if (it && it.response.data.url.indexOf(url) !== -1) {
          this.fileList.splice(i, 1)
        }
      })
      if (this.multiple) {
        if(this.join){
          this.$emit('update:modelValue', this.urls.join(','))
          this.$emit('change', this.urls.join(','))
        }else{
          this.$emit('update:modelValue', this.urls)
          this.$emit('change', this.urls)
        }
      } else {
        document.getElementById(this.uploadDomId).getElementsByClassName('el-upload__input')[0].removeAttribute('disabled')
        this.$emit('update:modelValue', '')
        this.$emit('change', '')
      }
      this.$delete('/system/file/delete', { url: encodeURI(url) })
    },
    handlePreview(file) {
      window.open(this.$global.baseApi + file.response.data.url)
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 ${this.limit} 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`)
    },
    beforeRemove(file, fileList) {
      if(!this.showRemoveTip){
        return true
      }
      return this.$confirm(`确定移除 ${file.name}？`)
    },
    handleAvatarSuccess(res, file, fileList) {
      this.uploadLoading = false
      if (res.data) {
        this.urls.push(res.data.url)
        if (this.multiple) {
          if(this.join){
            this.$emit('update:modelValue', this.urls.join(','))
            this.$emit('change', this.urls.join(','))
          }else{
            this.$emit('update:modelValue', this.urls)
            this.$emit('change', this.urls)
          }
        } else {
          document.getElementById(this.uploadDomId).getElementsByClassName('el-upload__input')[0].setAttribute('disabled', '')
          this.$emit('update:modelValue', res.data.url)
          this.$emit('change', res.data.url)
        }
      }
      if(this.onSuccess){
        this.onSuccess(res, file, fileList)
      }
    },
    getSettingSuffixs() {
      if (this.formats) {
        return this.formats
      }
      var suffixs = this.acceptList[this.accept]
      if (!suffixs) {
        suffixs = this.getAllSuffixs()
      }
      return suffixs
    },
    beforeAvatarUpload(file, fileList) {
      this.uploadLoading = true
      var fileName = file.name
      var accepts = this.accept.split(',')
      if (accepts) {
        for (var i = 0; i < accepts.length; i++) {
          if (!this.validAccept(fileName, accepts[i])) {
            this.$message.error('上传文件格式只能为：' + this.getSettingSuffixs().replaceAll(',', '，'))
            return false
          }
        }
      } else {
        if (!this.validAccept(fileName, 'null')) {
          this.$message.error('上传文件格式只能为：' + this.getAllSuffixs().replaceAll(',', '，'))
          return false
        }
      }

      const isLt2M = file.size / 1024 / 1024 < this.maxFileSize
      if (!isLt2M) {
        this.$message.error(`上传文件大小不能超过 ${this.maxFileSize}MB！`)
        return isLt2M
      }
    },
    getAllSuffixs() {
      var suffixs = ''
      for (const key in this.acceptList) {
        suffixs += this.acceptList[key] + ','
      }
      suffixs = suffixs.substring(0, suffixs.length - 1)
      return suffixs
    },
    validAccept(fileName, accept) {
      if (this.formats) {
        return this.validEndsWith(fileName, this.formats)
      }
      if (accept && this.acceptList[accept]) {
        return this.validEndsWith(fileName, this.acceptList[accept])
      } else {
        return this.validEndsWith(fileName, this.getAllSuffixs())
      }
    },
    validEndsWith(fileName, suffixs) {
      suffixs = suffixs.split(',')
      for (var i = 0; i < suffixs.length; i++) {
        const suffix = suffixs[i]
        if (fileName.toLowerCase().endsWith('.' + suffix)) {
          return true
        }
      }
      return false
    }
  }
}
</script>

<style scoped>
  :deep(.el-upload){
    display: block;
  }
</style>

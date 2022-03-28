<template>
  <el-upload
    :id="uploadDomId"
    class="upload-demo"
    :action="action"
    :headers="headers"
    :on-preview="handlePreview"
    :on-remove="handleRemove"
    :before-remove="beforeRemove"
    :multiple="multiple"
    :limit="limit"
    :on-exceed="handleExceed"
    :file-list="fileList"
    :before-upload="beforeAvatarUpload"
    :on-success="handleAvatarSuccess"
  >
    <el-button size="small" type="primary" :disabled="!multiple && fileList.length == 1">点击上传</el-button>
    <div slot="tip" class="el-upload__tip">支持上传{{ getSettingSuffixs().replaceAll(',', '，') }}文件，且不超过{{ maxFileSize }}MB</div>
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
      action: import.meta.env.VITE_APP_BASE_API + 'file/upload',
      headers: {
        token: getToken()
      },
      urls: [],
      uploadDomId: Math.random(),
      fileList: []
    }
  },
  watch: {
    value(newValue) {
      this.renderFile()
    }
  },
  created() {
    if (this.externalId) {
      this.$get('/system/file/files', { externalId: this.externalId, externalType: this.externalType }).then(res => {
        const { data } = res
        this.fileList = data
      })
      this.action = this.action + `?externalId=${this.externalId}&externalType=${this.externalType}`
    } else {
      this.renderFile()
    }
  },
  methods: {
    renderFile() {
      if (this.value instanceof Array && this.value.length > 0) {
        this.fileList = this.value.map(it => {
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
        if (this.value) {
          this.fileList.push({
            name: this.value.substring(this.value.lastIndexOf('/') + 1),
            response: {
              data: {
                url: this.value
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
        this.$emit('update:modelValue', this.urls)
        this.$emit('change', this.urls)
      } else {
        document.getElementById(this.uploadDomId).getElementsByClassName('el-upload__input')[0].removeAttribute('disabled')
        this.$emit('update:modelValue', '')
        this.$emit('change', '')
      }
      this.$delete('file/delete', { url: encodeURI(url) })
    },
    handlePreview(file) {
      window.open(this.$global.baseApi + file.response.data.url)
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 ${this.limit} 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`)
    },
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除 ${file.name}？`)
    },
    handleAvatarSuccess(res, file, fileList) {
      if (res.data) {
        if (this.multiple) {
          this.urls.push(res.data.url)
          this.$emit('update:modelValue', this.urls)
          this.$emit('change', this.urls)
        } else {
          document.getElementById(this.uploadDomId).getElementsByClassName('el-upload__input')[0].setAttribute('disabled', '')
          this.$emit('update:modelValue', res.data.url)
          this.$emit('change', res.data.url)
        }
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

<style>

</style>

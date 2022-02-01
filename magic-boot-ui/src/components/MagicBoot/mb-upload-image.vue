<template>
  <div>
    <vuedraggable
      v-model="urls"
      class="vue-draggable"
      tag="div"
      draggable=".draggable-item"
      @end="onDragEnd"
    >
      <div
        v-for="(url, index) in urls"
        :key="index"
        class="draggable-item"
        :style="{ width: width.replace('px', '') + 'px', height: height.replace('px', '') + 'px' }"
      >
        <el-image
          :src="$filePrefix + url"
          :preview-src-list="[$filePrefix + url]"
        />
        <div class="tools">
          <div class="shadow" @click="handleRemove(url)">
            <i class="el-icon-delete" />
          </div>
          <div class="shadow" @click="beforeCropper(url)">
            <i class="el-icon-scissors" />
          </div>
        </div>
      </div>
      <el-upload
        v-if="(!multiple && urls.length == 0) || (multiple && urls.length < limit)"
        slot="footer"
        ref="uploadRef"
        class="uploadBox"
        :style="{ width: width.replace('px', '') + 'px', height: height.replace('px', '') + 'px' }"
        :action="action"
        :file-list="fileList"
        :headers="headers"
        accept=".jpg,.jpeg,.png,.gif"
        :show-file-list="false"
        :multiple="multiple"
        :limit="limit"
        :on-success="handleAvatarSuccess"
        :on-exceed="onExceed"
      >
        <i class="el-icon-plus uploadIcon">
          <span v-show="isUploading" class="uploading">正在上传...</span>
          <span
            v-if="!isUploading && limit && limit!==99 && multiple"
            class="limitTxt"
          >最多{{ limit }}张</span>
        </i>
      </el-upload>
    </vuedraggable>
    <mb-dialog ref="cropperDialog" @confirm-click="cropper">
      <template #content>
        <div class="cropper-content">
          <div class="cropper" style="text-align:center">
            <vue-cropper
              ref="cropper"
              v-bind="cropperOption"
              :output-size="cropperOption.outputSize === undefined ? 0.8 : cropperOption.outputSize"
              :output-type="cropperOption.outputType === undefined ? 'jpeg' : cropperOption.outputType"
              :can-move="cropperOption.canMove === undefined ? true : cropperOption.canMove"
              :can-move-box="cropperOption.canMoveBox === undefined ? true : cropperOption.canMoveBox"
              :auto-crop="cropperOption.autoCrop === undefined ? true : cropperOption.autoCrop"
              :center-box="cropperOption.centerBox === undefined ? true : cropperOption.centerBox"
            />
          </div>
        </div>
      </template>
    </mb-dialog>
  </div>
</template>

<script>
import { VueCropper } from 'vue-cropper'
import vuedraggable from 'vuedraggable'
import { getToken } from '@/scripts/auth'

export default {
  name: 'MbUploadImage',
  components: { vuedraggable, VueCropper },
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    value: {
      required: false
    },
    externalId: {
      type: String,
      default: ''
    },
    externalType: {
      type: String,
      default: ''
    },
    multiple: {
      type: Boolean,
      default: false
    },
    limit: {
      type: Number,
      default: 2
    },
    cropperConfig: {
      type: Object,
      default: () => {}
    },
    width: {
      type: String,
      default: '100'
    },
    height: {
      type: String,
      default: '100'
    }
  },
  data() {
    return {
      action: process.env.VUE_APP_BASE_API + 'file/upload',
      headers: {
        token: getToken()
      },
      dialogImageUrl: '',
      dialogVisible: false,
      disabled: false,
      isUploading: false,
      cropperOption: {},
      urls: [],
      fileList: []
    }
  },
  watch: {
    value(newValue) {
      if (newValue instanceof Array) {
        this.urls = newValue
        this.fileList = this.urls.map(it => { return { response: { data: { url: it }}} })
      } else {
        if (newValue && this.urls.length === 0) {
          this.urls.push(newValue)
        }
      }
    }
  },
  created() {
    this.cropperOption = this.cropperConfig || {}
    this.cropperOption.img = ''
    if (this.externalId) {
      this.$get('file/files', { externalId: this.externalId, externalType: this.externalType }).then(res => {
        this.urls = res.data
      })
      this.action = this.action + `?externalId=${this.externalId}&externalType=${this.externalType}`
    } else {
      if (this.value instanceof Array) {
        this.urls = this.value
        this.fileList = this.urls.map(it => { return { response: { data: { url: it }}} })
      } else {
        if (this.value) {
          this.urls.push(this.value)
        }
      }
    }
  },
  methods: {
    handleRemove(url) {
      this.urls.splice(this.urls.indexOf(url), 1)
      this.fileList.forEach((it, i) => {
        if (it && it.response.data.url.indexOf(url) !== -1) {
          this.fileList.splice(i, 1)
        }
      })
      this.$get('file/delete', { url: encodeURI(url) })
      if (this.multiple) {
        this.$emit('update:value', this.urls)
        this.$emit('change', this.urls)
      } else {
        this.$emit('update:value', '')
        this.$emit('change', '')
      }
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url
      this.dialogVisible = true
    },
    handleDownload(file) {
      console.log(file)
    },
    handleAvatarSuccess(res, file, fileList) {
      this.fileList = fileList
      if (res.data) {
        this.urls.push(res.data.url)
        if (this.multiple) {
          this.$emit('update:value', this.urls)
          this.$emit('change', this.urls)
        } else {
          this.$emit('update:value', res.data.url)
          this.$emit('change', res.data.url)
        }
        this.onDragEnd()
      } else {
        this.$message({ type: 'error', message: res.msg })
      }
      this.isUploading = false
    },
    onDragEnd() {
      var newUrls = []
      this.urls.forEach(url => {
        newUrls.push(encodeURI(url))
      })
      this.$get('file/resort', { urls: newUrls.join(',') })
    },
    onExceed() {
      this.$message({
        type: 'warning',
        message: `图片超限，最多可上传${this.limit}张图片`
      })
    },
    beforeCropper(url) {
      this.cropperOption.img = this.$filePrefix + url
      this.cropperOption.relativeImg = url
      this.$refs.cropperDialog.show()
    },
    cropper() {
      this.$refs.cropper.getCropBlob((data) => {
        var dataFile = new File([data], this.cropperOption.relativeImg.substring(this.cropperOption.relativeImg.lastIndexOf('/') + 1), { type: data.type, lastModified: Date.now() })
        var formData = new FormData()
        formData.append('file', dataFile)
        formData.append('url', encodeURI(this.cropperOption.relativeImg))
        this.$request({
          url: 'file/cropper',
          method: 'post',
          data: formData
        }).then(res => {
          this.urls.forEach((it, i) => {
            if (this.cropperOption.img.indexOf(it) !== -1) {
              this.$set(this.urls, i, res.data.url)
              this.$refs.cropperDialog.hide()
            }
          })
        })
      })
    }
  }
}
</script>

<style scoped>
.vue-draggable >>> .el-upload {
  width: 100%;
  height: 100%;
}
</style>

<style lang="scss" scoped>
// 上传按钮
.uploadIcon {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px dashed #c0ccda;
  background-color: #fbfdff;
  border-radius: 6px;
  font-size: 20px;
  color: #999;

  .limitTxt,
  .uploading {
    position: absolute;
    bottom: 10%;
    left: 0;
    width: 100%;
    font-size: 14px;
    text-align: center;
  }
}

// 拖拽
.vue-draggable {
  display: flex;
  flex-wrap: wrap;
  .draggable-item {
    margin-right: 5px;
    margin-bottom: 5px;
    border: 1px solid #ddd;
    border-radius: 6px;
    position: relative;
    overflow: hidden;

    .el-image {
      width: 100%;
      height: 100%;
    }
    .tools {
      position: absolute;
      top:0px;
      width: 100%;
      height: 20px;
    }
    .shadow {
      display: inline-block;
      background-color: rgba(0,0,0,.5);
      opacity: 0;
      transition: opacity .3s;
      color: #fff;
      font-size: 20px;
      line-height: 20px;
      padding: 2px;
      cursor: pointer;
    }
    &:hover {
      .shadow {
        opacity: 1;
      }
    }
  }
  &.hideShadow {
    .shadow {
      display: none;
    }
  }
  &.single {
    overflow: hidden;
    position: relative;

    .draggable-item {
      position: absolute;
      left: 0;
      top: 0;
      z-index: 1;
    }
  }
  &.maxHidden {
    .uploadBox {
      display: none;
    }
  }
}
// el-image
.el-image-viewer__wrapper {
  .el-image-viewer__mask {
    opacity: .8;
  }
  .el-icon-circle-close {
    color: #fff;
  }
}
.cropper-content {
    .cropper {
        width: auto;
        height: 300px;
    }
}
</style>

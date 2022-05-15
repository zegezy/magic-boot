<template>
  <div style="padding: 50px;">
    <h2>上传文件（单文件）</h2>
    <mb-upload-file v-model="fileUrl" @change="fileChange" />
    <h2>上传文件（多文件）</h2>
    <mb-upload-file v-model="fileUrls" @change="multipleFileChange" multiple />
    <h2>上传图片（id）</h2>
    <mb-upload-image :external-id="externalId" multiple :external-type="externalType" />
    <h2>上传图片（url、单图）</h2>
    <mb-upload-image v-model="imgUrl" @change="imgChange" tip="建议上传尺寸：710*345" />
    <h2>上传图片（url、多图）</h2>
    <mb-upload-image v-model="multipleImgUrl" :width="120" :height="120" multiple :limit="3" @change="multipleImgChange" />
  </div>
</template>

<script>

export default {
  name: 'UploadFile',
  data() {
    return {
      externalId: this.$common.uuid(),
      externalType: '营业执照',
      imgUrl: '',
      multipleImgUrl: '',
      fileUrl: '',
      fileUrls: ''
    }
  },
  methods: {
    fileChange() {
      console.log(this.fileUrl)
    },
    multipleFileChange() {
      console.log(this.fileUrls)
    },
    imgChange() {
      console.log(this.imgUrl)
    },
    multipleImgChange() {
      console.log(this.multipleImgUrl)
    }
  }
}
</script>

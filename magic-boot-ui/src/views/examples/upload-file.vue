<template>
  <div style="padding: 50px;">
    <h2>上传文件</h2>
    <pd-upload-file v-model="fileUrl" @change="fileChange" />
    <h2>上传图片（id）</h2>
    <pd-upload-image :external-id="externalId" multiple :external-type="externalType" />
    <h2>上传图片（url、单图）</h2>
    <pd-upload-image v-model="imgUrl" @change="imgChange" />
    <h2>上传图片（url、多图）</h2>
    <pd-upload-image v-model="multipleImgUrl" width="120" height="120" multiple :limit="3" @change="multipleImgChange" />
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
      fileUrl: ''
    }
  },
  methods: {
    fileChange() {
      console.log(this.fileUrl)
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

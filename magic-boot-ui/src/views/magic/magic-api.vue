<template>
  <div class="app-container" style="padding:0;width:100%;height: calc(100vh - 85px);">
    <magic-editor :config="config" />
  </div>
</template>
<script>
// 引入组件
import MagicEditor from 'magic-editor'
// 引入样式
import 'magic-editor/dist/magic-editor.css'
import { getToken } from '@/scripts/auth'

export default {
  name: 'MagicApi',
  components: {
    MagicEditor
  },
  data() {
    return {
      config: {
        baseURL: process.env.VUE_APP_BASE_API + 'magic/web', // 配置后台服务
        serverURL: process.env.VUE_APP_BASE_API, // 配置接口实际路径
        request: {
          beforeSend: (config) => {
            config.headers['token'] = getToken()
            return config
          }
        }
      }
    }
  }
}
</script>

import Vue from 'vue'

import 'normalize.css/normalize.css' // A modern alternative to CSS resets

import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

import '@/styles/index.scss' // global css
import '@/styles/common.css'

import App from './App'
import store from './store'
import router from './router'

import '@/icons' // icon
import '@/permission' // permission control
import './scripts/error-log' // error log

import elDragDialog from '@/directive/el-drag-dialog' // base on element-ui
Vue.use(elDragDialog)

import common from '@/scripts/common'
Vue.prototype.$common = common

import request from '@/scripts/request'
Vue.prototype.$request = request
Vue.prototype.$post = (url, data) => request.post(url, data, {
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded'
  },
  transformRequest: [data => Object.keys(data).map(it => encodeURIComponent(it) + '=' + encodeURIComponent(data[it] === null || data[it] === undefined ? '' : data[it])).join('&')]
})
Vue.prototype.$postJson = (url, data) => request.post(url, JSON.stringify(data), {
  headers: {
    'Content-Type': 'application/json'
  }
})
Vue.prototype.$get = (url, data) => request({ url, params: data })

import hasPermission from '@/scripts/hasPermission'
Vue.use(hasPermission)

import vuedraggable from 'vuedraggable'
Vue.component('vuedraggable', vuedraggable)

const requireComponent = require.context(
  // 其组件目录的相对路径
  '@/components/Psyduck/',
  // 是否查询其子目录
  true,
  // 匹配基础组件文件名的正则表达式
  /\.vue$/
)
requireComponent.keys().forEach(fileName => {
  // 获取组件配置
  const componentConfig = requireComponent(fileName)
  // 全局注册组件
  Vue.component(
    // 此处的name,是组件属性定义的name
    fileName.substring(fileName.lastIndexOf('/') + 1).replace('.vue', ''),
    // componentConfig.default.name,
    // 如果这个组件选项是通过 `export default` 导出的，
    // 那么就会优先使用 `.default`，
    // 否则回退到使用模块的根。
    componentConfig.default
  )
})

Vue.prototype.$bus = new Vue()

// set ElementUI lang to EN
// Vue.use(ElementUI, { locale })
// 如果想要中文版 element-ui，按如下方式声明
Vue.use(ElementUI, {
  size: 'small'
})

Vue.config.productionTip = false

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})

document.body.addEventListener('keydown', e => {
  if (e.altKey && e.ctrlKey && e.shiftKey && e.key === 'A') {
    router.push('/magic/magic-api')
  }
})

import * as vue from 'vue'
const libs = { vue }
window.___magic__import__ = function(lib, name){
  return (libs[lib] || {})[name]
}

import { createApp } from 'vue'
const app = createApp(App)
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import '@/assets/css/common.css'
import zhCn from 'element-plus/es/locale/lang/zh-cn'
import 'vite-plugin-svg-icons/register'
import App from './App.vue'
import router from './scripts/router'
import components from '@/components/index'
import globalProperties from './scripts/globalProperties'
import hasPermission from './scripts/hasPermission'

import '@/permission'
import global from '@/scripts/global.js'
document.title = global.title
router.beforeEach((to, from) => {
  global.tabValue.value = to.path
  if((to.name && global.visitedViews.length === 0 || global.visitedViews.every(it => it.path !== to.path)) && !to.path.startsWith('/redirect')){
    global.visitedViews.push(to)
  }
  return true
})
app.use(globalProperties)
app.use(hasPermission)
app.use(components)
app.use(ElementPlus, {
  // size: 'small',
  locale: zhCn
})
app.use(router)
app.mount('#app')

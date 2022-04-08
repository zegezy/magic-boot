import {createApp} from 'vue'
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
import { appComponent } from './scripts/dynamicComponent'
import '@/permission'
import global from '@/scripts/global.js'
import '@/scripts/magic-import'
app.use(globalProperties)

var loadDynamicComponent = false
import { ElLoading } from 'element-plus'
document.title = global.title
router.beforeEach(async (to, from) => {
  global.tabValue.value = to.path
  if((to.name && global.visitedViews.length === 0 || global.visitedViews.every(it => it.path !== to.path)) && !to.path.startsWith('/redirect') && !to.path.startsWith('/login')){
    if(!loadDynamicComponent){
      loadDynamicComponent = true
      const loading = ElLoading.service({
        lock: true,
        background: 'rgba(255, 255, 255, 0)',
      })
      await app.config.globalProperties.$post('/system/component/list').then((res) => {
        res.data.forEach(it => {
          global.dynamicComponentNames.push(it.name)
          appComponent(app, it)
        })
        loading.close()
      })
    }
    global.visitedViews.push(to)
  }
  global.visitedViews.forEach((it, i) => {
    if(it.path == to.path){
      global.visitedViews[i] = to
    }
  })
  return true
})
app.use(hasPermission)
app.use(components)
app.use(ElementPlus, {
  // size: 'small',
  locale: zhCn
})
app.use(router)
app.mount('#app')

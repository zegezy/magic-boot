import request from '@/scripts/request'
import common from '@/scripts/common'
import { sha256 } from 'js-sha256'

const viewModules = import.meta.glob("../views/**/**.vue")
const layoutModules = import.meta.glob("../layout/**.vue")

export const filterAsyncRouter = (routers, level) => {
  level = level || 0
  const accessedRouters = routers.filter(router => {
    if (router.isShow === 1) {
      var setIframe = () => {
        router.component = loadView(`/common/iframe`)
        router.props = { url: router.url }
        router.path = "/" + sha256(router.url)
      }
      var setLayout = () => {
        router.path = "/" + common.uuid()
        router.component = level > 0 ? layoutModules[`../layout/none.vue`] : loadLayoutView()
      }
      if(router.url && router.url.startsWith('http')){
        if(router.openMode == '0'){
          setIframe()
        }
      } else if(router.url && router.url.startsWith('/') && router.url.indexOf('.htm') != -1) {
        if(router.openMode == '0'){
          setIframe()
        }else{
          router.path = location.href.substring(0, location.href.indexOf('/', location.href.indexOf('/', location.href.indexOf('/') + 1) + 1)) + router.path
        }
      } else if (router.componentName) {
        router.component = loadView(`/common/show-component`)
        router.props = { name: router.componentName }
      } else if (router.component) {
        const component = router.component
        if (component === 'Layout') {
          if (router.children && router.children.length > 0) {
            const children = filterAsyncRouter(router.children, level + 1);
            if(!children.some(it => it.isShow == 0)){
              router.children = children
              setLayout()
            }else{
              router.children = undefined
              router.alwaysShow = false
              router.redirect = ''
              router.path = router.path.startsWith('/') ? router.path : '/' + router.path
              router.component = loadView(router.path) || layoutModules[`../layout/empty.vue`]
            }
          }else{
            setLayout()
          }
        } else {
          router.path = router.path.startsWith('/') ? router.path : '/' + router.path
          router.component = loadView(component) || layoutModules[`../layout/empty.vue`]
        }
      }
      return true
    } else if (router.componentName) {
      router.component = loadView(`/common/show-component`)
      router.props = { name: router.componentName }
      return true
    }
    return false
  })
  return accessedRouters
}

export const loadLayoutView = () => {
  return layoutModules[`../layout/layout.vue`]
}

export const loadView = (view) => {
  view = view.substring(0, 1) === '/' ? view : '/' + view
  return viewModules[`../views${view}.vue`]
}

export function generateRoutes(){
  return new Promise((resolve, reject) => {
    request({
      url: '/system/menu/current/menus',
      method: 'post'
    }).then(response => {
      const { data } = response
      const asyncRouter = filterAsyncRouter(data)
      resolve(asyncRouter)
    })
  })
}

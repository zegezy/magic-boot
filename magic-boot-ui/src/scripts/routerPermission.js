import request from '@/scripts/request'
import common from '@/scripts/common'

const viewModules = import.meta.glob("../views/**/**.vue")
const layoutModules = import.meta.glob("../layout/**.vue")

export const filterAsyncRouter = (routers, level) => {
  level = level || 0
  const accessedRouters = routers.filter(router => {
    if (router.isShow === 1) {
      if (router.componentName) {
        router.component = loadView(`/common/show-component`)
        router.props = { name: router.componentName }
      } else if (router.component) {
        const component = router.component
        if (component === 'Layout') {
          router.path = "/" + common.uuid()
          router.component = level > 0 ? layoutModules[`../layout/none.vue`] : loadLayoutView(component)
        } else {
          router.path = router.path = router.path.startsWith('/') ? router.path : '/' + router.path
          router.component = loadView(component)
        }
      }
      if (router.children && router.children.length) {
        router.children = filterAsyncRouter(router.children, level + 1)
      }
      return true
    }
    return false
  })
  return accessedRouters
}

export const loadLayoutView = (view) => {
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

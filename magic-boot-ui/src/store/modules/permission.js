import { constantRoutes } from '@/router'
import { getCurrentUserMenu } from '@/api/menu'
import common from '@/scripts/common'

const state = {
  routes: [],
  addRoutes: []
}

const mutations = {
  SET_ROUTES: (state, routes) => {
    state.addRoutes = routes
    state.routes = constantRoutes.concat(routes)
  }
}

export const filterAsyncRouter = (routers, level) => {
  level = level || 0
  const accessedRouters = routers.filter(router => {
    if (router.isShow === 1) {
      if (router.isListConfig === 0 && router.listConfig) {
        router.component = loadView(`/common/list`)
        router.listConfig = JSON.parse(router.listConfig)
        if (router.formConfig) {
          router.listConfig.formConfig = JSON.parse(router.formConfig)
        }
        router.props = router.listConfig
      } else if (router.component) {
        const component = router.component
        if (component === 'Layout') {
          router.path = common.uuid()
          router.component = level > 0 ? (resolve) => require([`@/layout/none.vue`], resolve) : loadLayoutView(component)
        } else {
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
  return (resolve) => require([`@/layout/index`], resolve)
}

export const loadView = (view) => {
  view = view.substring(0, 1) === '/' ? view : '/' + view
  return (resolve) => require([`@/views${view}`], resolve)
}

const actions = {
  generateRoutes({ commit }) {
    return new Promise((resolve, reject) => {
      getCurrentUserMenu().then(response => {
        const { data } = response
        const asyncRouter = filterAsyncRouter(data)
        commit('SET_ROUTES', asyncRouter)
        resolve(asyncRouter)
      })
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

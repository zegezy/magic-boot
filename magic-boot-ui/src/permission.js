import router from './scripts/router'
import { getUserInfo, removeToken } from './scripts/auth'
import { ElMessage } from 'element-plus'
import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import { getToken } from '@/scripts/auth' // get token from cookie
import global from '@/scripts/global'
import common from '@/scripts/common'
import { generateRoutes, generateHiddenRoutes } from '@/scripts/routerPermission'

NProgress.configure({ showSpinner: false }) // NProgress Configuration

const whiteList = ['/login'] // no redirect whitelist
var loadInfo = false
router.beforeEach(async(to, from, next) => {
  // start progress bar
  NProgress.start()

  // determine whether the user has logged in
  const hasToken = getToken()

  if (hasToken) {
    if (to.path === '/login') {
      // if is logged in, redirect to the home page
      next({ path: '/' })
      NProgress.done()
    } else {
      // determine whether the user has obtained his permission roles through getInfo
      if (loadInfo) {
        next()
      } else {
        loadInfo = true
        try {
          // get user info
          // note: roles must be a object array! such as: ['admin'] or ,['developer','editor']
          await getUserInfo()
          await common.getDictData()
          // await common.loadConfig()
          // generate accessible routes map based on roles
          await generateRoutes().then(accessRoutes => {
            global.user.permissionRoutes.push(...accessRoutes)
            accessRoutes.forEach(it => {
              router.addRoute(it)
            })
          })
          await generateHiddenRoutes().then(accessRoutes => {
            accessRoutes.forEach(it => {
              router.addRoute(it)
            })
          })
          // dynamically add accessible routes
          // hack method to ensure that addRoutes is complete
          // set the replace: true, so the navigation will not leave a history record
          next({ ...to, replace: true })
        } catch (error) {
          console.log(error)
          // remove token and go to login page to re-login
          removeToken()
          ElMessage.error(error.data || 'Has Error')
          next(`/login`)
          NProgress.done()
        }
      }
    }
  } else {
    /* has no token*/

    if (whiteList.indexOf(to.path) !== -1) {
      // in the free login whitelist, go directly
      next()
    } else {
      // other pages that do not have permission to access are redirected to the login page.
      next(`/login`)
      NProgress.done()
    }
  }
})

router.afterEach(() => {
  // finish progress bar
  NProgress.done()
})


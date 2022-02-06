
const hasPermission = {
  install(Vue, options) {
    Vue.directive('permission', {
      bind(el, binding, vnode) {
        if (binding.value) {
          const permissionList = Vue.prototype.$authorities
          if (permissionList && permissionList.length && !permissionList.includes(binding.value) && process.env.NODE_ENV != 'preview') {
            el.style.display = 'none'
          }
        }
      }
    })
  }
}

export default hasPermission

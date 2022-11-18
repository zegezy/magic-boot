
const hasPermission = {
  install(app) {
    app.directive('permission', {
      mounted(el, binding) {
        if (binding.value) {
          const permissionList = app.config.globalProperties.$global.user.authorities
          if (permissionList && permissionList.length && !permissionList.includes(binding.value) && import.meta.env.MODE != 'demo') {
            el.remove()
          }
        }
      }
    })
  }
}

export default hasPermission

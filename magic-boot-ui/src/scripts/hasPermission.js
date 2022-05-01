
const hasPermission = {
  install(app) {
    app.directive('permission', {
      beforeMount(el, binding) {
        if (binding.value) {
          const permissionList = app.config.globalProperties.$global.user.authorities
          if (permissionList && permissionList.length && !permissionList.includes(binding.value) && import.meta.env.MODE != 'demo') {
            el.style.display = 'none'
          }
        }
      }
    })
  }
}

export default hasPermission

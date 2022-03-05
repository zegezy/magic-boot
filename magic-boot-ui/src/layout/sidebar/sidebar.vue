<template>
  <el-menu
    :default-active="activeMenu"
    class="aside-menu"
  >
    <sidebar-item v-for="(route,index) in permissionRoutes" :key="route.path + index" :item="route" :base-path="route.path" />
  </el-menu>
</template>

<script setup>
  import SidebarItem from './sidebar-item.vue'
  import { getCurrentInstance, computed } from 'vue'
  const { proxy } = getCurrentInstance()
  const permissionRoutes = proxy.$global.user.permissionRoutes
  const activeMenu = computed(() => {
    const route = proxy.$route
    const { meta, path } = route
    // if set path, the sidebar will highlight the path you set
    if (meta.activeMenu) {
      return meta.activeMenu
    }
    return path
  })
</script>

<style scoped>
  .aside-menu{
    height: 100%;
  }
  .aside-menu :deep(a){
    text-decoration: none;
  }
</style>
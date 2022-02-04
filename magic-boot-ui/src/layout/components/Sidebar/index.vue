<template>
  <div :class="{'has-logo':showLogo}">
    <div class="logo-title">
      <div v-if="!isCollapse" style="color: white">
        Magic-Boot
      </div>
      <img v-if="isCollapse" src="@/assets/magic-boot.png" style="vertical-align: middle; width: 28px">
    </div>
    <logo v-if="showLogo" :collapse="isCollapse" />
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :background-color="variables.menuBg"
        :text-color="variables.menuText"
        :unique-opened="false"
        :active-text-color="variables.menuActiveText"
        :collapse-transition="false"
        mode="vertical"
      >
        <sidebar-item v-for="(route,index) in permission_routes" :key="route.path + index" :item="route" :base-path="route.path" />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<style scoped>
  .el-scrollbar >>> .el-scrollbar__wrap{
    height: calc(100% - 60px)
  }
  .logo-title {
    color:white;
    height: 60px;
    font-size: 24px;
    line-height: 60px;
    text-align: center;
    font-weight: 300;
    box-shadow: 0px -1px 5px 0px #000;
    z-index: 1;
    position: relative;
    font-family: PoetsenOne;
  }
</style>

<script>
import { mapGetters } from 'vuex'
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/styles/variables.scss'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  components: { SidebarItem, Logo },
  computed: {
    ...mapGetters([
      'permission_routes',
      'sidebar'
    ]),
    activeMenu() {
      const route = this.$route
      const { meta, path } = route
      // if set path, the sidebar will highlight the path you set
      if (meta.activeMenu) {
        return meta.activeMenu
      }
      return path
    },
    showLogo() {
      return this.$store.state.settings.sidebarLogo
    },
    variables() {
      return variables
    },
    isCollapse() {
      return !this.sidebar.opened
    }
  },
  data() {
    return {
      menuTree: []
    }
  }
}
</script>

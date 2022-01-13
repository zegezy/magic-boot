<template>
  <div :class="{'has-logo':showLogo}">
    <div class="logo-title">
      <img src="@/assets/psyduck.png" style="vertical-align: middle">
      <span v-if="!isCollapse">
        magic-boot
      </span>
    </div>
    <logo v-if="showLogo" :collapse="isCollapse" />
    <el-form v-if="!isCollapse">
      <el-form-item>
        <treeselect
          style="width: 90%;margin: 0px 5%"
          :options="menuTree"
          placeholder="输入菜单名称搜索查找"
          :disable-branch-nodes="true"
          :show-count="true"
          @select="selectMenu"
        />
      </el-form-item>
    </el-form>
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
  .el-form-item--small.el-form-item{
    margin-bottom: 0px;
  }
  .el-scrollbar >>> .el-scrollbar__wrap{
    height: calc(100% - 60px - 36px)
  }
  .logo-title {
    color:white;
    height: 60px;
    font-size: 16px;
    line-height: 60px;
    text-align: center;
    font-weight: 300;
    /*box-shadow: 0px -1px 5px 0px #000;*/
    z-index: 1;
    position: relative;
  }
</style>

<script>
import { mapGetters } from 'vuex'
import Logo from './Logo'
import SidebarItem from './SidebarItem'
import variables from '@/styles/variables.scss'
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
import treeTable from "@/scripts/treeTable";

export default {
  components: { SidebarItem, Logo, Treeselect },
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
  },
  mounted() {
    this.$get('menu/search').then(res => {
      this.menuTree = res.data.list
      this.$treeTable.deleteEmptyChildren(this.menuTree)
    })
  },
  methods: {
    selectMenu(node) {
      if(node.url){
        this.$router.push({ path: node.url })
      }
    }
  }
}
</script>

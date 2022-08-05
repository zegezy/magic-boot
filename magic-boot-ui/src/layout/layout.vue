<template>
  <el-container class="container">
    <el-header>
      <div class="title">
        {{ $global.title }}
      </div>
      <div class="header-right">
        <div class="avatar">
          <el-dropdown>
            <el-row :gutter="24">
              <el-col :span="6">
                <el-avatar v-if="$global.user.info.headPortrait" :size="40" fit="contain" :src="$global.baseApi + $global.user.info.headPortrait"></el-avatar>
                <el-avatar v-else :size="40" fit="contain">
                  {{ $global.user.info.name.substring(0,1) }}
                </el-avatar>
              </el-col>
              <el-col :span="18" style="line-height: 40px;">
                <span class="username">{{ $global.user.info.username }}</span>
                <el-icon class="el-icon--right" color="white">
                  <arrow-down />
                </el-icon>
              </el-col>
            </el-row>
            <template #dropdown>
              <el-dropdown-menu>
                <router-link to="/user-center">
                  <el-dropdown-item>个人中心</el-dropdown-item>
                </router-link>
                <el-dropdown-item @click="logout">退出</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </el-header>
    <el-container class="main-container">
      <el-aside width="var(--mb-sidebar-width)">
        <sidebar />
      </el-aside>
      <el-container>
        <el-header class="tabs">
          <tabs />
        </el-header>
        <div class="main-box">
          <el-main>
            <router-view v-slot="{ Component }">
              <keep-alive>
                <component v-if="$route.meta.keepAlive" :is="Component" :key="$route.path" />
              </keep-alive>
              <component v-if="!$route.meta.keepAlive" :is="Component" :key="$route.path" />
            </router-view>
          </el-main>
        </div>
      </el-container>
    </el-container>
  </el-container>
</template>

<script setup>
import { ArrowDown } from '@element-plus/icons-vue'
import Tabs from './tabs.vue'
import Sidebar from './sidebar/sidebar.vue'
import { logout } from '@/scripts/auth'
</script>

<style scoped>
  .container{
    height: 100%;
  }
  .main-container{
    height: calc(100% - var(--mb-header-height));
  }
  .title{
    font-family: PoetsenOne;
    line-height: 60px;
    font-size: 24px;
    color: white;
    padding-left: 20px;
    box-sizing: border-box;
    float: left;
  }
  .header-right{
    float: right;
    height: 100%;
    margin-right: 10px;
  }
  .header-right .username{
    font-size: 14px;
    color: white;
    margin: 0px 5px;
  }
  .header-right .avatar{
    height: 100%;
    display: flex;
    align-items: center;
  }
  .header-right .avatar :deep(.el-avatar--circle){
    align-items: center;
  }
  .container > .el-header{
    background: #409EFF;
    padding: 0px;
  }
  .tabs{
    margin-left: -21px;
    height: 40px;
  }
  .tabs :deep(.el-tabs__header){
    margin: 0px;
  }
  .main-box{
    padding: 10px;
    background-color: #F0F2F5;
    height: 100%;
    overflow: auto;
  }
  .el-main{
    border-radius: 10px;
    background-color: white;
    height: 100%;
    overflow: auto;
    position: relative;
  }
</style>

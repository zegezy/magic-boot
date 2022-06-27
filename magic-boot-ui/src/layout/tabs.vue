<template>
  <el-tabs
    v-model="tabValue"
    type="card"
    class="demo-tabs"
    @tab-click="openTab"
    @tab-remove="removeTab"
  >
    <el-tab-pane
      v-for="(view, key) in global.visitedViews" :key="key"
      :label="view.meta.title"
      :name="view.path"
      :closable="!(view.path == '/home')"
    >
      <template #label>
        <el-dropdown trigger="contextmenu">
          <div class="el-tabs__item is-top is-closable is-focus" style="padding: 0px;" v-if="$route.path != view.path">
            {{ view.meta.title }}
          </div>
          <div class="el-tabs__item is-top is-active is-closable is-focus" style="padding: 0px;" v-else>
            {{ view.meta.title }}
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item @click="refresh(view.path)">刷新</el-dropdown-item>
              <el-dropdown-item @click="close('left', view.path)">关闭左侧</el-dropdown-item>
              <el-dropdown-item @click="close('right', view.path)">关闭右侧</el-dropdown-item>
              <el-dropdown-item @click="close('other', view.path)">关闭其他</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </template>
    </el-tab-pane>
  </el-tabs>
</template>

<script setup>
  import { getCurrentInstance, ref, watch } from 'vue'
  import global from '@/scripts/global.js'
  const { proxy } = getCurrentInstance()
  const tabValue = ref(proxy.$route.path)
  watch(global.tabValue, () => {
    tabValue.value = global.tabValue.value
  })
  function openTab(item){
    proxy.$router.push({
      path: item.props.name,
      query: global.visitedViews.filter(it => it.path == item.props.name)[0].query
    })
  }
  function removeTab(path){
    if(global.visitedViews.length == 1){
      global.visitedViews.splice(0, 1)
      proxy.$router.push({
        path: '/home'
      })
    }else{
      global.visitedViews.forEach((it, i) => {
        if(it.path == path){
          global.visitedViews.splice(i, 1)
          proxy.$router.push({
            path: global.visitedViews[global.visitedViews.length - 1].path,
            query: global.visitedViews[global.visitedViews.length - 1].query
          })
        }
      })
    }
  }
  function refresh(path){
    proxy.$router.replace({
      path: `/redirect${path}`,
      query: global.visitedViews.filter(it => it.path == path)[0].query
    })
  }
  function close(type, path){
    if(type == 'other'){
      for(var i = global.visitedViews.length - 1; i >= 0; i--){
        if(global.visitedViews[i].path != path){
          global.visitedViews.splice(i, 1)
        }
      }
    }else if(type == 'right'){
      for(var i = global.visitedViews.length - 1; i >= 0; i--){
        if(global.visitedViews[i].path != path){
          global.visitedViews.splice(i, 1)
        }else{
          break;
        }
      }
    }else{
      for(var i = 0, len = global.visitedViews.length; i < len; i++){
        if(global.visitedViews[0].path != path){
          global.visitedViews.splice(0, 1)
        }else{
          break;
        }
      }
    }
    proxy.$router.push({
      path: path,
      query: global.visitedViews.filter(it => it.path == path)[0].query
    })
  }
</script>

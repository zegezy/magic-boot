<template>
  <router-view v-slot="{ Component }">
    <keep-alive>
      <component v-if="$route.meta.keepAlive" :is="Component" :key="$route.path" />
    </keep-alive>
    <component v-if="!$route.meta.keepAlive" :is="Component" :key="$route.path" />
  </router-view>
</template>
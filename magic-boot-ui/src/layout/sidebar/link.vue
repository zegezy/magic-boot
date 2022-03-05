
<template>
  <a v-if="isExternal(to)" :href="to" target="_blank" rel="noopener">
    <slot />
  </a>
  <router-link v-else :to="to">
    <slot />
  </router-link>
</template>

<script setup>
import { isExternal } from '@/scripts/validate'

const props = defineProps({
  to: String
})
</script>

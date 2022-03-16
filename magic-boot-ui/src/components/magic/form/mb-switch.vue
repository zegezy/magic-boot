<template>
  <el-switch
    v-model="modelValue"
    :active-value="activeValue"
    :inactive-value="inactiveValue"
    v-bind="props.props"
  />
</template>

<script setup>
  import { watch } from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const props = defineProps({
    modelValue: {
      type: Boolean,
      default: false
    },
    activeValue: Boolean | String | Number,
    inactiveValue: Boolean | String | Number,
    props: Object
  })
  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

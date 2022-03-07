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
    modelValue: String,
    activeValue: String,
    inactiveValue: String,
    props: Object
  })
  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

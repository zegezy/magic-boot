<template>
  <el-input v-model="modelValue" :type="type" :placeholder="placeholder || (itemLabel && '请输入' + itemLabel)" v-bind="props.props" />
</template>

<script setup>
  import { watch } from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const props = defineProps({
    modelValue: String,
    itemLabel: String,
    placeholder: String,
    type: String,
    props: Object
  })
  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

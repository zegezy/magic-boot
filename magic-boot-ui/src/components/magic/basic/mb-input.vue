<template>
  <el-input v-model="modelValue" :type="type" :value="value" :placeholder="placeholder || (label && '请输入' + label)" v-bind="props.props" />
</template>

<script setup>
  import { watch } from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const props = defineProps({
    modelValue: String,
    label: String,
    placeholder: String,
    value: String,
    type: String,
    props: Object
  })
  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

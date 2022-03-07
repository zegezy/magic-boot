<template>
  <el-radio-group v-model="modelValue" v-bind="props.props">
    <el-radio-button v-for="it in options" :label="it.value" :disabled="it.disabled" :name="it.disabled">{{ it.label }}</el-radio-button>
  </el-radio-group>
</template>

<script setup>
  import { watch } from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const props = defineProps({
    modelValue: String,
    options: Array
  })
  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

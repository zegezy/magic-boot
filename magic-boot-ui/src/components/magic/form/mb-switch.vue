<template>
  <el-switch
    v-model="selectValue"
    :active-value="activeValue"
    :inactive-value="inactiveValue"
    v-bind="props.props"
  />
</template>

<script setup>
import {ref, watch} from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const selectValue = ref(false)
  const props = defineProps({
    modelValue: {
      type: Boolean,
      default: false
    },
    activeValue: Boolean | String | Number,
    inactiveValue: Boolean | String | Number,
    props: Object
  })

  selectValue.value = props.modelValue
  watch(() => props.modelValue, (value) => {
    selectValue.value = value
  })
  watch(selectValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

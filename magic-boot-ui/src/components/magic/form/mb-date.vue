<template>
  <el-date-picker
    v-model="selectValue"
    :type="type"
    :format="format"
    :value-format="valueFormat"
    :placeholder="placeholder"
    :start-placeholder="startPlaceholder"
    :end-placeholder="endPlaceholder"
    v-bind="props.props"
  />
</template>

<script setup>
  import { watch, ref } from 'vue'
  const emit = defineEmits(['update:modelValue'])
  const selectValue = ref('')
  const props = defineProps({
    modelValue: String,
    type: String,
    placeholder: {
      type: String,
      default: '请选择时间'
    },
    format: {
      type: String,
      default: 'YYYY-MM-DD'
    },
    startPlaceholder: {
      type: String,
      default: '开始时间'
    },
    endPlaceholder: {
      type: String,
      default: '结束时间'
    },
    props: Object
  })

  selectValue.value = props.modelValue
  watch(() => props.modelValue, (value) => {
    selectValue.value = value
  })
  const valueFormat = ref(props.format)
  watch(selectValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

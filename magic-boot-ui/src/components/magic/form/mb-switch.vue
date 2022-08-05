<template>
  <el-switch
      v-model="selectValue"
      :active-value="activeValue + ''"
      :inactive-value="inactiveValue  + ''"
      v-bind="props.props"
  />
</template>

<script setup>
import {ref, watch} from 'vue'
const emit = defineEmits(['update:modelValue'])
const selectValue = ref('')
const props = defineProps({
  modelValue: Boolean | String | Number,
  activeValue: Boolean | String | Number,
  inactiveValue: Boolean | String | Number,
  props: Object
})

dynamicSetValue(props.modelValue)
watch(() => props.modelValue, (value) => {
  dynamicSetValue(value)
})
function dynamicSetValue(value){
  if(typeof(value) == 'boolean'){
    selectValue.value = value
  }else{
    if(value || value == 0){
      selectValue.value = value + ''
    }
  }
}
watch(selectValue, (value) => {
  emit('update:modelValue', value)
})
</script>

<template>
  <el-switch
      v-model="selectValue"
      :active-value="_activeValue"
      :inactive-value="_inactiveValue"
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
const _activeValue = ref(true)
const _inactiveValue = ref(false)

function setActive(value){
  if(typeof(value) == 'boolean'){
    if(props.activeValue == undefined && props.inactiveValue == undefined){
      _activeValue.value = true
      _inactiveValue.value = false
    }else{
      _activeValue.value = props.activeValue
      _inactiveValue.value = props.inactiveValue
    }
  }else{
    if(value || value == 0){
      if(props.activeValue == undefined && props.inactiveValue == undefined){
        _activeValue.value = '1'
        _inactiveValue.value = '0'
      }else{
        _activeValue.value = props.activeValue + ''
        _inactiveValue.value = props.inactiveValue + ''
      }
    }else{
      _activeValue.value = true
      _inactiveValue.value = false
    }
  }
}

dynamicSetValue(props.modelValue)
setActive(props.modelValue)
watch(() => props.modelValue, (value) => {
  dynamicSetValue(value)
  setActive(value)
})
function dynamicSetValue(value){
  if(typeof(value) == 'boolean'){
    selectValue.value = value
  }else{
    if(value || value == 0){
      selectValue.value = value + ''
    }else{
      selectValue.value = false
    }
  }
}
watch(selectValue, (value) => {
  emit('update:modelValue', value)
})
</script>

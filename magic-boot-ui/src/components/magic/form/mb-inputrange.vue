<template>
  <el-input v-model="input1" />
  <span>-</span>
  <el-input v-model="input2" />
</template>

<script setup>
import { ref, watch } from 'vue'
const emit = defineEmits(['update:modelValue'])
const props = defineProps({
  modelValue: {
    type: String,
    default: ''
  },
  itemLabel: String
})
const input1 = ref('')
const input2 = ref('')
if(props.modelValue){
  input1.value = props.modelValue.split(',')[0]
  input2.value = props.modelValue.split(',')[1]
}

watch([input1, input2], () => {
  emit('update:modelValue', input1.value + ',' + input2.value)
})
</script>

<style scoped>
  .el-input{
    display: inline-block;
    width: 47%;
  }
  span{
    margin: 0px 8px;
  }
</style>

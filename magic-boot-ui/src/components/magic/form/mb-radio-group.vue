<template>
  <el-radio-group
    v-model="modelValue"
    :size="size"
    :disabled="disabled"
    :text-color="textColor"
    :fill="fill"
    @change="change"
  >
    <el-radio-button v-if="button" v-for="it in options" v-bind="it" :label="it[valueField]">
      {{ it[labelField] }}
    </el-radio-button>
    <el-radio  v-if="!button" v-for="it in options" v-bind="it" :label="it[valueField]">
      {{ it[labelField] }}
    </el-radio>
  </el-radio-group>
</template>

<script setup>
  import {watch, ref, getCurrentInstance} from "vue";
  import request from '@/scripts/request'
  const emit = defineEmits(['update:modelValue', 'change'])
  const { proxy } = getCurrentInstance()

  const props = defineProps({
    modelValue: String | Number | Boolean,
    type: String,
    button: {
      type: Boolean,
      default: false
    },
    options: Array,
    url: String,
    params: Object,
    method: {
      type: String,
      default: 'get'
    },
    labelField: {
      type: String,
      default: 'label'
    },
    valueField: {
      type: String,
      default: 'value'
    },
    size: String,
    disabled: {
      type: Boolean,
      default: false
    },
    textColor: {
      type: String,
      default: '#fff'
    },
    fill: {
      type: String,
      default: '#409EFF'
    }
  })

  const options = ref([])

  if(props.type){
    options.value = proxy.$common.getDictType(props.type)
  }else if(props.url){
    request({
      url: props.url,
      method: props.method,
      params: props.params,
      data: props.params
    }).then(res => {
      options.value = res.data.list || res.data
    })
  }else if(props.options){
    options.value = props.options
  }

  function change(value){
    emit('change', value)
  }

  watch(() => props.modelValue, (value) => {
    emit('update:modelValue', value)
  })
</script>

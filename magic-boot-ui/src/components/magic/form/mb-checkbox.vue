<template>
  <el-checkbox-group
    v-model="modelValue"
    :size="size"
    :disabled="disabled"
    :min="min"
    :max="max"
    :text-color="textColor"
    :fill="fill"
    @change="change"
  >
    <el-checkbox-button v-if="button" v-for="it in options" v-bind="it" :label="it[valueField]">
      {{ it[labelField] }}
    </el-checkbox-button>
    <el-checkbox v-if="!button" v-for="it in options" v-bind="it" :label="it[valueField]">
      {{ it[labelField] }}
    </el-checkbox>
  </el-checkbox-group>
</template>

<script setup>
import {watch, ref, getCurrentInstance} from "vue";
  import request from '@/scripts/request'
  const emit = defineEmits(['update:modelValue', 'change'])
  const { proxy } = getCurrentInstance()

  const props = defineProps({
    modelValue: {
      type: Array,
      default: () => []
    },
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
    min: Number,
    max: Number,
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
    console.log(value)
    emit('update:modelValue', value)
  })
</script>

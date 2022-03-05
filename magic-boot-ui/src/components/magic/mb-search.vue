<template>
  <div class="filter-container">
    <el-form :inline="true" @keyup.enter="search">
      <el-form-item :label="it.label" v-for="(it, i) in where" :key="i">
        <el-input v-if="it.type == 'input'" @input="input(it.input)" v-model="it.value" :placeholder="it.placeholder || ('请输入' + it.label)" style="width: 200px;" class="filter-item" />
        <mb-select v-else-if="it.type == 'select'" v-model="it.value" :placeholder="'请输入' + it.label" v-bind="it.properties" />
        <el-date-picker
          v-else-if="it.type == 'date' || it.type == 'datetime' || it.type == 'daterange' || it.type == 'datetimerange'"
          v-model="it.value"
          align="right"
          :format="it.type.startsWith('datetime') ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd'"
          :value-format="it.type.startsWith('datetime') ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd'"
          :type="it.type"
          :start-placeholder="it.type.startsWith('datetime') ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd'"
          :end-placeholder="it.type.startsWith('datetime') ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd'"
          :placeholder="it.type.startsWith('datetime') ? 'yyyy-MM-dd HH:mm:ss' : 'yyyy-MM-dd'"
        >
        </el-date-picker>
        <component v-else :is="it.type" v-model="it.value" v-bind="it.properties" />
      </el-form-item>
      <el-form-item>
        <el-button class="filter-item" type="primary" icon="ElSearch" @click="search">
          搜索
        </el-button>
        <el-button class="filter-item" icon="ElDelete" @click="reset">
          清空
        </el-button>
      </el-form-item>
      <el-form-item>
        <slot name="btns" />
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>

import { nextTick, watch } from 'vue'

const props = defineProps({
  where: {
    type: Object,
    default: () => {}
  },
  notReset: {
    type: String,
    default: ''
  }
})

watch(() => props.where,() => {
  console.log(props.where)
})

const emit = defineEmits(['search'])

function input(input){
  if(input){
    emit('search')
  }
}

function search(){
  for(var key in props.where){
    if(props.where[key] instanceof Object){
      if(props.where[key].type.startsWith('date') && props.where[key].value instanceof Array){
        props.where[key].value = props.where[key].value.join(',')
      }
    }
  }
  nextTick(() => {
    emit('search')
    for(var key in props.where){
      if(props.where[key] instanceof Object){
        if(props.where[key].type.startsWith('date')){
          props.where[key].value = props.where[key].value.split(',')
        }
      }
    }
  })
}

function reset() {
  for(var key in props.where){
    if(props.notReset.indexOf(key) == -1){
      if(props.where[key] instanceof Object){
        props.where[key].value = null
      }else{
        props.where[key] = null
      }
    }
  }
  nextTick(() => emit('search'))
}

</script>

<style scoped>

</style>

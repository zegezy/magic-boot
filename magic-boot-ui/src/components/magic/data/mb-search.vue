<template>
  <div class="filter-container">
    <el-form :inline="true" @keyup.enter="search">
      <span v-for="(it, i) in where">
        <el-form-item v-if="it && it.label" :label="it.label" :key="i">
          <el-input v-if="!it.type || it.type == 'input'" @input="input(it.input)" v-model="it.value" :placeholder="it.placeholder || ('请输入' + it.label)" style="width: 200px;" class="filter-item" />
          <mb-select v-else-if="it.type == 'select'" v-model="it.value" :placeholder="'请选择' + it.label" v-bind="it.properties" />
          <el-date-picker
            v-else-if="it.type == 'date' || it.type == 'datetime' || it.type == 'daterange' || it.type == 'datetimerange'"
            v-model="it.value"
            align="right"
            :format="it.type.startsWith('datetime') ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'"
            :value-format="it.type.startsWith('datetime') ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'"
            :type="it.type"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            :placeholder="it.type.startsWith('datetime') ? 'YYYY-MM-DD HH:mm:ss' : 'YYYY-MM-DD'"
          >
          </el-date-picker>
          <mb-inputrange v-model="it.value" v-else-if="it.type == 'inputrange'" />
          <component v-else :is="it.type" v-model="it.value" v-bind="it.properties" />
        </el-form-item>
      </span>
      <el-form-item>
        <el-button class="filter-item" type="primary" icon="ElSearch" @click="search">
          搜索
        </el-button>
        <el-button class="filter-item" icon="ElDelete" @click="reset">
          清空
        </el-button>
        <slot name="btns" />
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>

import { nextTick, watch, onMounted } from 'vue'

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

for(var key in props.where){
  if(props.where[key] instanceof Object && props.where[key].value == undefined){
    props.where[key].value = null
  }
}

const emit = defineEmits(['search', 'mounted'])

function input(input){
  if(input){
    emit('search')
  }
}

function search(){
  for(var key in props.where){
    if(props.where[key] instanceof Object){
      if(props.where[key].type && props.where[key].type.startsWith('date') && props.where[key].value instanceof Array && props.where[key].value.join(',')){
        props.where[key].value = props.where[key].value.join(',')
      }
    }
  }
  nextTick(() => {
    emit('search')
    for(var key in props.where){
      if(props.where[key] instanceof Object){
        if(props.where[key].type && props.where[key].type.startsWith('date') && props.where[key].value){
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
        if(props.where[key].value instanceof Array){
          props.where[key].value = []
        }else{
          props.where[key].value = null
        }
      }else{
        if(props.where[key] instanceof Array){
          props.where[key] = []
        }else{
          props.where[key] = null
        }
      }
    }
  }
  nextTick(() => emit('search'))
}

onMounted(() => {
  emit('mounted')
})

</script>

<style scoped>

</style>

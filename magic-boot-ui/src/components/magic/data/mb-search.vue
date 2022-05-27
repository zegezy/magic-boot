<template>
  <div class="filter-container">
    <el-form :inline="true" @keyup.enter="search">
      <span v-for="(it, i) in where">
        <el-form-item v-if="it && it.label" :label="it.label" :key="i">
          <component
              :is="!it.component ? 'mb-input' : it.component.startsWith('el-') || $global.dynamicComponentNames.indexOf(it.component) != -1 ? it.component : 'mb-' + it.component"
              v-model="it.value"
              :item-label="it.label"
              v-bind="it.props"
          />
        </el-form-item>
      </span>
      <el-form-item>
        <el-button class="filter-item" type="primary" icon="ElIconSearch" @click="search">
          搜索
        </el-button>
        <el-button class="filter-item" icon="ElIconDelete" @click="reset">
          清空
        </el-button>
        <slot name="btns" />
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>

import { nextTick } from 'vue'

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

const emit = defineEmits(['search'])

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

</script>

<style scoped>

</style>

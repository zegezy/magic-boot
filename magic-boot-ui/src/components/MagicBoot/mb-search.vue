<template>
  <div class="filter-container">
    <el-form :inline="true" @keyup.enter.native="search">
      <el-form-item :label="it.label" v-for="it in where">
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
      <el-button class="filter-item" type="primary" icon="el-icon-search" @click="search">
        搜索
      </el-button>
      <el-button class="filter-item" icon="el-icon-delete" @click="reset">
        清空
      </el-button>
      <slot name="btns" />
    </el-form>
  </div>
</template>

<script>
export default {
  name: "MbSearch",
  props: {
    where: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
    }
  },
  methods: {
    input(input){
      if(input){
        this.$emit('search')
      }
    },
    search(){
      for(var key in this.where){
        if(this.where[key] instanceof Object){
          if(this.where[key].type.startsWith('date') && this.where[key].value instanceof Array){
            this.where[key].value = this.where[key].value.join(',')
          }
        }
      }
      this.$nextTick(() => {
        this.$emit('search')
        for(var key in this.where){
          if(this.where[key] instanceof Object){
            if(this.where[key].type.startsWith('date')){
              this.where[key].value = this.where[key].value.split(',')
            }
          }
        }
      })
    },
    reset() {
      for(var key in this.where){
        if(this.where[key] instanceof Object){
          this.where[key].value = ''
        }else{
          this.where[key] = ''
        }
      }
      this.$nextTick(() => this.$emit('search'))
    }
  }
}
</script>

<style scoped>

</style>

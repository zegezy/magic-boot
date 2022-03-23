<template>
  <div style="padding: 50px;">
    <el-button type="primary" @click="getData" style="margin-bottom: 10px">获取数据</el-button>
    <el-button type="primary" @click="gen" style="margin-bottom: 10px">代码生成</el-button>
    <mb-editor-table v-model="tableDatas" :cols="cols" :show-no="false" :operation="false" />
  </div>
</template>

<script setup>
import { reactive,getCurrentInstance } from 'vue'
import genCode from '@/scripts/gen/gen-mb-list.js'
const { proxy } = getCurrentInstance()
const tableDatas = reactive([])

proxy.$get('/code/gen/columns', { tableName: 'sys_user' }).then(res => {
  var columns = res.data.columns
  var primary = res.data.primary
  columns.forEach(it => {
    tableDatas.push({
      columnName: it.columnName,
      columnComment: it.columnComment,
      dataType: it.dataType
    })
  })
  console.log(tableDatas)
})

const cols = reactive([{
  field: 'columnName',
  label: '列名'
}, {
  field: 'columnComment',
  label: '列说明',
  component: 'input'
}, {
  field: 'dataType',
  label: '字段类型'
}, {
  field: 'save',
  label: '保存',
  component: 'switch',
  width: '80px'
}, {
  field: 'list',
  label: '列表',
  component: 'switch',
  width: '80px'
}, {
  field: 'query',
  label: '查询',
  component: 'switch',
  width: '80px'
}, {
  field: 'where',
  label: '匹配方式',
  component: 'select',
  props: {
    options: [{
      label: '=',
      value: '='
    },{
      label: '!=',
      value: '!='
    },{
      label: '>',
      value: '>'
    },{
      label: '>=',
      value: '>='
    },{
      label: '<',
      value: '<'
    },{
      label: '<=',
      value: '<='
    },{
      label: 'Between',
      value: 'Between'
    },{
      label: 'Like',
      value: 'Like'
    },{
      label: '左Like',
      value: '左Like'
    },{
      label: '右Like',
      value: '右Like'
    }]
  }
}, {
  field: 'required',
  label: '必填',
  component: 'switch',
  width: '80px'
}, {
  field: 'component',
  label: '控件类型',
  component: 'select',
  props: {
    options: [{
      label: '单行文本框',
      value: 'input'
    },{
      label: '多行文本框',
      value: 'textarea'
    },{
      label: '单选下拉框',
      value: 'radioSelect'
    },{
      label: '多选下拉框',
      value: 'multipleSelect'
    },{
      label: '单选按钮',
      value: 'radio'
    },{
      label: '复选框',
      value: 'checkbox'
    },{
      label: '日期选择',
      value: 'date'
    },{
      label: '日期时间',
      value: 'datetime'
    },{
      label: '图片上传',
      value: 'uploadImage'
    },{
      label: '文件上传',
      value: 'uploadFile'
    }]
  }
}, {
  component: 'select',
  field: 'dictType',
  label: '字典类型',
  props: {
    url: 'dict/all',
    showValue: true
  }
}])

function gen(){
  genCode('user', tableDatas)
}

function getData(){
  console.log(tableDatas)
}

</script>

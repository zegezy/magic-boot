<template>
  <div>
    <el-row style="margin-bottom: 6px">
      <el-button type="primary" @click="addRow">添加一行</el-button>
    </el-row>
    <mb-table ref="magicTable" v-bind="tableOptions">
      <template v-for="col in cols" #[col.field]="{ index }">
        <div v-if="!col.component">
          {{ tableOptions.data[index][col.field] }}
        </div>
        <component
          v-else
          :is="col.component.startsWith('el-') ? col.component : 'mb-' + col.component"
          v-model="tableOptions.data[index][col.field]"
          v-bind="col.props"
          @change="dataChange"
        />
      </template>
    </mb-table>
  </div>
</template>

<script setup>

import { reactive, ref, watch } from 'vue'

const emit = defineEmits(['update:modelValue', 'change'])

const magicTable = ref()
const props = defineProps({
  modelValue: Array,
  cols: {
    type: Array,
    default: () => []
  },
  showNo: {
    type: Boolean,
    default: true
  }
})

const tableOptions = reactive({
  data: [],
  cols: [],
  showNo: props.showNo
})

for (var i in props.cols) {
  var col = props.cols[i]
  tableOptions.cols.push({
    type: 'dynamic',
    field: col.field,
    label: col.label
  })
}

tableOptions.cols.push({
  label: '操作',
  type: 'btns',
  width: 85,
  fixed: 'right',
  btns: [{
    label: '删除',
    type: 'danger',
    click: (row, index) => {
      tableOptions.data.splice(index, 1)
    }
  }]
})

watch(() => props.modelValue, (value) => {
  console.log(value)
  tableOptions.data = value
}, {
  deep: true
})

function addRow(){
  tableOptions.data.push({})
  magicTable.value.reloadList()
}

function dataChange() {
  console.log('更新')
  console.log(tableOptions.data)
  emit('update:modelValue', tableOptions.data)
  emit('change', tableOptions.data)
}

</script>

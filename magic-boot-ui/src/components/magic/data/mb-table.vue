<template>
  <div>
    <el-table
      :key="tableKey"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      v-bind="props.props"
      style="width: 100%;"
      @sort-change="sortChange"
      @selection-change="selectionChange"
    >

      <el-table-column v-if="selection" align="center" type="selection" width="50" />

      <el-table-column v-if="showNo" label="序号" prop="num" align="center" width="65">
        <template #default="scope">
          <span>{{ scope.$index+1 }}</span>
        </template>
      </el-table-column>

      <mb-table-column v-for="(col, i) in cols" :key="i" :col="col">
        <template v-for="(value, key) in $slots" #[key]="{ row, index }">
          <slot :row="row" :index="index" :name="key" />
        </template>
      </mb-table-column>

      <template empty>
        <el-empty :description="emptyText"  />
      </template>

    </el-table>
    <mb-pagination v-show="total > 0 && page" :total="total || 0" v-model:page="listCurrent" v-model:limit="limit" @pagination="handlerPagination" />
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted, getCurrentInstance } from 'vue'
import common from "../../../scripts/common";

const { proxy } = getCurrentInstance()

const props = defineProps({
  props: {
    type: Object,
    default: () => {}
  },
  url: {
    type: String,
    default: ''
  },
  limit: {
    type: Number,
    default: 10
  },
  page: {
    type: Boolean,
    default: true
  },
  done: {
    type: Function,
    default: () => {}
  },
  where: {
    type: Object,
    default: () => {
      return {}
    }
  },
  showNo: {
    type: Boolean,
    default: true
  },
  selection: {
    type: Boolean,
    default: false
  },
  data: {
    type: Array,
    default: null
  },
  method: {
    type: String,
    default: 'post'
  },
  cols: {
    type: Array,
    default: () => []
  },
  emptyText: {
    type: String,
    default: '暂无数据'
  }
})
const emit = defineEmits(['selection-change'])

const listCurrent = ref(1)
const total = ref(0)
const list = ref([])
const listLoading = ref(false)
const tableKey = ref(0)
let newWhere = reactive({})

function renderWhere(){
  newWhere = reactive(proxy.$common.renderWhere(props.where))
}

function getList() {
  renderWhere()
  listLoading.value = true
  if (props.page) {
    newWhere.current = listCurrent.value
    newWhere.size = props.limit
  } else {
    newWhere.size = 99999999
  }
  var then = (res) => {
    const { data } = res
    total.value = data.total
    list.value = data.list
    listLoading.value = false
    props.done()
  }
  if(props.method.toLowerCase() == 'post'){
    proxy.$post(props.url, newWhere).then(res => {
      then(res)
    })
  }else{
    proxy.$get(props.url, newWhere).then(res => {
      then(res)
    })
  }
}

function sortChange(column) {
  let order = column.order
  if (order) {
    order = order === 'descending' ? 'desc' : ''
    order = column.prop + ' ' + order
  } else {
    order = null
  }
  newWhere.orderBy = order
  reload()
}

function selectionChange(columns) {
  emit('selection-change', columns)
}

function reload() {
  if (props.url) {
    newWhere.current = 1
    listCurrent.value = 1
    getList()
  }
  if (props.data) {
    handlerData()
  }
}

function renderExportData(sourceData){
  var data = []
  var fields = props.cols.filter(it => it.type != 'btns')
  sourceData.forEach(it => {
    var row = {}
    fields.forEach(f => {
      if(f.exportTemplet){
        row[f.label] = f.exportTemplet(it)
      }else if(f.templet){
        row[f.label] = f.templet(it)
      }else{
        row[f.label] = it[f.field]
      }
    })
    data.push(row)
  })
  return data
}

function exportExcel(){
  if(props.url){
    var where = proxy.$common.renderWhere(props.where)
    where.size = 99999999
    var then = (res) => {
      const { data } = res
      proxy.$common.exportExcel({
        data: renderExportData(data.list),
        fileName: '用户数据'
      })
    }
    if(props.method.toLowerCase() == 'post'){
      proxy.$post(props.url, where).then(res => {
        then(res)
      })
    }else{
      proxy.$get(props.url, where).then(res => {
        then(res)
      })
    }
  }else if(props.data){
    proxy.$common.exportExcel({
      data: props.data,
      fileName: '用户数据'
    })
  }
}

function handlerData() {
  listLoading.value = true
  total.value = props.data.length
  var currPageData = []
  if(props.page){
    props.data.forEach((it, i) => {
      if (i >= ((listCurrent.value - 1) * props.limit) && i < (listCurrent.value * props.limit) && currPageData.length < props.limit) {
        currPageData.push(it)
      }
    })
  }else{
    currPageData = props.data
  }
  list.value = currPageData
  props.done()
  listLoading.value = false
}

function handlerPagination() {
  if (props.url) {
    getList()
  }
  if (props.data) {
    handlerData()
  }
}

function keyup(){
  document.onkeyup = (e) => {
    if(e.target.nodeName != 'INPUT'){
      if (e && e.keyCode == 37) {
        if(listCurrent.value != 1){
          listCurrent.value -= 1
          handlerPagination()
        }
      } else if (e && e.keyCode == 39) {
        if(listCurrent.value != parseInt((total.value + props.limit - 1) / props.limit)){
          listCurrent.value += 1
          handlerPagination()
        }
      }
    }
  }
}

watch(() => props.data, () => {
  listCurrent.value = 1
  handlerData()
},{ deep: true })

watch(() => props.where,() => {
  renderWhere()
},{ deep: true })

renderWhere()

onMounted(() => {
  keyup()
  if (props.data) {
    handlerData()
  }
  if (props.url) {
    getList()
  }
})

defineExpose({ reload, exportExcel })

</script>

<style scoped>
  .el-table :deep(.el-image .el-image__inner) {
    max-height: 100px;
    width: auto;
    height: auto;
  }
  .el-table :deep(.el-table__cell){
    z-index: auto;
  }
</style>

<style>
  .el-table-column--selection .cell {
    padding:0px 15px!important;
  }
  .el-table th {
    background: #F5F7FA;
  }
</style>

<template>
  <div>
    <div style="margin-bottom: 5px;" v-if="expand || checked">
      <el-button v-if="expand" type="primary" icon="ElIconSort" plain @click="doExpand">展开/折叠</el-button>
      <el-button v-if="checked" type="primary" icon="ElIconCheck" plain @click="() => { treeAllChecked = !treeAllChecked; checkedAll(treeData, treeAllChecked) }">全选/全不选</el-button>
    </div>
    <div style="margin-bottom: 5px;" v-if="search">
      <el-input v-model="searchValue" placeholder="输入关键字进行过滤" @input="tree.filter(searchValue)" :style="{ width: searchWidth }" />
    </div>
    <el-tree
        v-if="refreshTree"
        ref="tree"
        :data="treeData"
        v-bind="props.props"
        node-key="id"
        :default-expand-all="defaultExpandAll"
        :default-checked-keys="checkedIds"
        @check-change="checkChange"
        @node-click="nodeClick"
        :props="defaultProps"
        :filter-node-method="searchTree"
        :style="style"
    />
  </div>
</template>

<script setup>

import { watch, ref, reactive, defineExpose, nextTick, getCurrentInstance, onBeforeMount, onMounted } from 'vue'

const { proxy } = getCurrentInstance()

const emit = defineEmits(['update:select-values', 'check-change', 'node-click', 'mounted'])

const props = defineProps({
  url: {
    type: String,
    default: ''
  },
  params: {
    type: Object,
    default: () => {}
  },
  selectValues: {
    type: String,
    default: ''
  },
  style: {
    type: Object,
    default: () => {}
  },
  props: {
    type: Object,
    default: () => {}
  },
  expand: {
    type: Boolean,
    default: true
  },
  checked: {
    type: Boolean,
    default: true
  },
  search: {
    type: Boolean,
    default: false
  },
  searchWidth: {
    type: String,
    default: '230px'
  }
})

const checkedIds = ref(props.selectValues.split(','))

const tree = ref()
const treeData = ref([])
const defaultProps = reactive({
  children: 'children',
  label: 'name'
})
const defaultExpandAll = ref(true)
const refreshTree = ref(false)
const treeAllChecked = ref(false)
const searchValue = ref('')

onBeforeMount(async () => {
  await loadTreeData()
})

onMounted(() => {
  emit('mounted')
})

watch(() => props.selectValues, async () => {
  checkedIds.value = props.selectValues.split(',')
})

function searchTree(value, data) {
  if (!value) return true
  return data.name.includes(value)
}

function doExpand() {
  refreshTree.value = false
  defaultExpandAll.value = !defaultExpandAll.value
  nextTick(() => refreshTree.value = true)
}

async function loadTreeData() {
  if(treeData.value.length == 0){
    await proxy.$get(props.url, props.params).then((res) => {
      treeData.value = res.data.list
    })
    refreshTree.value = true
  }
}

function getTree() {
  return tree.value
}

function checkChange(node) {
  var selectMenus = []
  var checkedNodes = tree.value.getCheckedNodes(false, true)
  for (var i = 0; i < checkedNodes.length; i++) {
    selectMenus.push(checkedNodes[i].id)
  }
  console.log(selectMenus.join(','))
  emit('update:select-values', selectMenus.join(','))
  emit('check-change', selectMenus.join(','))
}

function nodeClick(param1, param2, param3){
  emit('node-click', param1, param2, param3)
}

function checkedAll(children, checked) {
  if (tree.value) {
    for (var i in children) {
      var id = children[i].id
      if(children[i].children && children[i].children.length > 0){
        checkedAll(children[i].children, checked)
      }
      tree.value.setChecked(id, checked, true)
    }
  }
}

defineExpose({ getTree })

</script>


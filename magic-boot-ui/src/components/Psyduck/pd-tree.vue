<template>
  <div>
    <div style="margin-bottom: 5px;" v-if="expand || checked">
      <el-button v-if="expand" type="primary" size="mini" icon="el-icon-sort" plain @click="doExpand">展开/折叠</el-button>
      <el-button v-if="checked" type="primary" size="mini" icon="el-icon-check" plain @click="() => { treeAllChecked = !treeAllChecked; checkedAll(searchData, treeAllChecked) }">全选/全不选</el-button>
    </div>
    <div style="margin-bottom: 5px;" v-if="search">
      <el-input v-model="searchValue" placeholder="输入关键字进行过滤" @input="searchTree" :style="{ width: searchWidth }" />
    </div>
    <el-tree
      v-if="refreshTree"
      ref="tree"
      :data="searchData"
      v-bind="el"
      node-key="id"
      :default-expand-all="defaultExpandAll"
      @check-change="checkChange"
      @node-click="nodeClick"
      :props="defaultProps"
      :style="{ 'max-height': maxHeight ? maxHeight : '100%' }"
      style="overflow: auto"
    />
  </div>
</template>

<script>
export default {
  name: 'PdTree',
  props: {
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
    maxHeight: {
      type: String,
      default: ''
    },
    el: {
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
  },
  watch: {
    async selectValues() {
      await this.loadTreeData()
      this.checkedAll(this.searchData, false)
      var values = this.selectValues.split(',');
      for(var i in values){
        this.$refs.tree.setChecked(values[i], true, false)
      }
    }
  },
  data() {
    return {
      treeData: [],
      searchData: [],
      defaultProps: {
        children: 'children',
        label: 'name'
      },
      defaultExpandAll: true,
      refreshTree: true,
      treeAllChecked: false,
      searchValue: ''
    }
  },
  async created() {
    await this.loadTreeData()
  },
  methods: {
    searchTree() {
      if(this.searchValue){
        this.searchData = this.$treeTable.recursionSearch(['name'], this.$common.copyNew(this.treeData), this.searchValue, false)
      }else{
        this.searchData = this.treeData
      }
    },
    doExpand() {
      this.refreshTree = false
      this.defaultExpandAll = !this.defaultExpandAll
      this.$nextTick(() => this.refreshTree = true)
    },
    async loadTreeData() {
      if(this.treeData.length == 0){
        await this.$get(this.url, this.params).then((res) => {
          this.treeData = res.data.list
          this.searchData = this.treeData
        })
      }
    },
    getTree() {
      return this.$refs.tree
    },
    checkChange(node) {
      var selectMenus = []
      var checkedNodes = this.$refs.tree.getCheckedNodes(false, true)
      for (var i = 0; i < checkedNodes.length; i++) {
        selectMenus.push(checkedNodes[i].id)
      }
      this.$emit('update:select-values', selectMenus.join(','))
      this.$emit('check-change', selectMenus.join(','))
    },
    nodeClick(param1, param2, param3){
      this.$emit('node-click', param1, param2, param3)
    },
    checkedAll(children, checked) {
      if (this.$refs.tree) {
        for (var i in children) {
          var id = children[i].id
          if(children[i].children && children[i].children.length > 0){
            this.checkedAll(children[i].children, checked)
          }
          this.$refs.tree.setChecked(id, checked, true)
        }
      }
    }
  }
}
</script>


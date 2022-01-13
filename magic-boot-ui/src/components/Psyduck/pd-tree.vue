<template>
  <div>
    <el-button v-if="expand" type="primary" size="mini" icon="el-icon-sort" plain @click="doExpand">展开/折叠</el-button>
    <el-button v-if="checked" type="primary" size="mini" icon="el-icon-check" plain @click="() => { treeAllChecked = !treeAllChecked; checkedAll(treeData, treeAllChecked) }">全选/全不选</el-button>
    <el-tree
      v-if="refreshTree"
      ref="tree"
      :data="treeData"
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
    }
  },
  watch: {
    async selectValues() {
      await this.loadTreeData()
      this.checkedAll(this.treeData, false)
      var values = this.selectValues.split(',');
      for(var i in values){
        this.$refs.tree.setChecked(values[i], true, false)
      }
    }
  },
  data() {
    return {
      treeData: [],
      defaultProps: {
        children: 'children',
        label: 'name'
      },
      defaultExpandAll: true,
      refreshTree: true,
      treeAllChecked: false
    }
  },
  async created() {
    await this.loadTreeData()
  },
  methods: {
    doExpand() {
      this.refreshTree = false
      this.defaultExpandAll = !this.defaultExpandAll
      this.$nextTick(() => this.refreshTree = true)
    },
    async loadTreeData() {
      if(this.treeData.length == 0){
        await this.$get(this.url, this.params).then((res) => {
          this.treeData = res.data.list
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


<template>
  <div>
    <el-row style="margin-bottom: 6px">
      <el-button type="primary" @click="tableOptions.data.push({})">添加一行</el-button>
    </el-row>
    <mb-table v-bind="tableOptions">
      <template v-for="col in cols" #[col.field]="{ index }">
        <el-input v-if="col.type === 'input'" v-bind="col.properties" v-model="tableOptions.data[index][col.field]" @change="dataChange" />
        <mb-select v-else-if="col.type === 'select'" v-bind="col.properties" v-model="tableOptions.data[index][col.field]" @change="dataChange" />
      </template>
    </mb-table>
  </div>
</template>

<script>

export default {
  name: 'MbEditorTable',
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    // eslint-disable-next-line vue/require-prop-types
    value: {
      required: true
    },
    cols: {
      type: Array,
      default: () => []
    },
    showNo: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      tableOptions: {
        data: [],
        cols: [],
        showNo: this.showNo
      }
    }
  },
  created() {
    for (var i in this.cols) {
      var col = this.cols[i]
      this.tableOptions.cols.push({
        type: 'dynamic',
        field: col.field,
        title: col.title
      })
    }
    this.tableOptions.cols.push({
      title: '操作',
      type: 'btns',
      width: 85,
      fixed: 'right',
      btns: [{
        title: '删除',
        type: 'danger',
        click: (row, index) => {
          this.tableOptions.data.splice(index, 1)
        }
      }]
    })
  },
  methods: {
    dataChange() {
      console.log('更新')
      this.$emit('update:value', this.tableOptions.data)
      this.$emit('change', this.tableOptions.data)
    }
  }
}
</script>

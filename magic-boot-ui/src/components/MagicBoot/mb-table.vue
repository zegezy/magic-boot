<template>
  <div>
    <el-table
      :key="tableKey"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      v-bind="el"
      style="width: 100%;"
      @sort-change="sortChange"
      @selection-change="selectionChange"
    >

      <el-table-column v-if="selection" align="center" type="selection" width="50" />

      <el-table-column v-if="showNo" label="序号" prop="num" align="center" width="100">
        <template slot-scope="row">
          <span>{{ row.$index+1 }}</span>
        </template>
      </el-table-column>

      <mb-table-column v-for="(col, i) in cols" :key="i" :col="col">
        <template v-for="(value, key) in $scopedSlots" #[key]="{ row, index }">
          <slot :row="row" :index="index" :name="key" />
        </template>
      </mb-table-column>

      <el-empty :description="emptyText" slot="empty" />

    </el-table>
    <pagination v-show="total > 0 && page" :total="total || 0" :page.sync="listCurrent" :limit.sync="limit" @pagination="handlerPagination" />
  </div>
</template>

<script>
import request from '@/scripts/request'
import Pagination from '@/components/Pagination'
import MbTableColumn from './mb-table-column.vue'

export default {
  name: 'MbTable',
  components: { Pagination, MbTableColumn },
  props: {
    el: {
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
      default: 'get'
    },
    cols: {
      type: Array,
      default: () => {
        return []
      }
    },
    emptyText: {
      type: String,
      default: '暂无数据'
    }
  },
  data() {
    return {
      listCurrent: 1,
      total: 0,
      list: [],
      listLoading: false,
      tableKey: 0
    }
  },
  watch: {
    data() {
      this.listCurrent = 1
      this.handlerData()
    }
  },
  created() {
  },
  mounted() {
    if (this.data) {
      this.handlerData()
    }
    if (this.url) {
      this.getList()
    }
  },
  methods: {
    getList() {
      this.listLoading = true
      if (this.page) {
        this.where.current = this.listCurrent
        this.where.size = this.limit
      } else {
        this.where.size = 99999999
      }
      request({
        url: this.url,
        method: this.method,
        params: this.where
      }).then(res => {
        const { data } = res
        this.total = data.total
        this.list = data.list
        this.listLoading = false
        this.done()
      })
    },
    sortChange(column) {
      let order = column.order
      if (order) {
        order = order === 'descending' ? 'desc' : ''
        order = column.prop + ' ' + order
      } else {
        order = null
      }
      this.where.orderBy = order
      this.reloadList()
    },
    selectionChange(columns) {
      this.$emit('selection-change', columns)
    },
    reloadList() {
      if (this.url) {
        this.where.current = 1
        this.listCurrent = 1
        this.getList()
      }
    },
    handlerData() {
      this.listLoading = true
      this.total = this.data.length
      var currPageData = []
      this.data.forEach((it, i) => {
        if (i >= ((this.listCurrent - 1) * this.limit) && i < (this.listCurrent * this.limit) && currPageData.length < this.limit) {
          currPageData.push(it)
        }
      })
      this.list = currPageData
      this.done()
      this.listLoading = false
    },
    handlerPagination() {
      if (this.url) {
        this.getList()
      }
      if (this.data) {
        this.handlerData()
      }
    }
  }
}
</script>

<style scoped>
  .el-image >>> .el-image__inner {
    max-height: 100px;
    width: auto;
    height: auto;
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

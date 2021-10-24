<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item v-for="col in queryOptions.cols" :key="col.field" :label="col.title">
          <el-input v-if="col.type === 'input'" v-model="tableOptions.where[col.field]" v-bind="col.el" :placeholder="'请输入'+col.title" :style="col.style" />
          <pd-select v-else-if="col.type === 'select'" v-model="tableOptions.where[col.field]" v-bind="col.el" width="100%" />
        </el-form-item>
        <el-form-item v-for="(btn, i) in queryOptions.btns" :key="i">
          <el-button v-if="btn.type == 'query'" class="filter-item" type="primary" icon="el-icon-search" @click="reloadTable">
            搜索
          </el-button>
          <el-button v-if="btn.type == 'export'" :loading="downloadLoading" class="filter-item" type="primary" icon="el-icon-download" @click="handleDownload">
            导出
          </el-button>
        </el-form-item>
      </el-form>
    </div>

    <template v-if="toolOptions && toolOptions.btns">
      <hr>
      <el-row class="tool-row">
        <div v-for="(btn, i) in toolOptions.btns" :key="'toolBtn' + i">
          <el-button v-if="btn.btnType == 'add'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
            添加
          </el-button>
          <pd-button
            v-else
            :el="btn.el || {}"
            :request-url="btn.request.url"
            :request-data="toolBtnData[i]"
            :btn-type="btn.btnType"
            :before-confirm="btn.beforeConfirm"
            :is-open="btn.isOpen"
            :success-tips="btn.successTips"
            :fail-tips="btn.failTips"
            :after-handler="btn.afterHandler"
          />
        </div>
      </el-row>
      <hr>
    </template>

    <pd-table ref="table" v-bind="tableOptions" @selection-change="selectionChange" />

    <pd-dialog :params="formParams" v-bind="formConfig && formConfig.dialog" :visible.sync="dialogFormVisible" @confirm-click="$refs.inputForm.save()">
      <template #content>
        <common-form ref="inputForm" v-bind="formConfig" :visible.sync="dialogFormVisible" :dialog-status="dialogStatus" @reload-table="reloadTable" />
      </template>
    </pd-dialog>

  </div>
</template>

<script>
import CommonForm from './form'

var _this
export default {
  name: 'CommonList',
  components: { CommonForm },
  props: {
    formConfig: {
      type: Object,
      default: () => {}
    },
    queryOptions: {
      type: Object,
      default: () => {}
    },
    toolOptions: {
      type: Object,
      default: () => {}
    },
    tableOptions: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      formParams: {},
      formComponent: '',
      dialogFormVisible: false,
      dialogStatus: 'create',
      downloadLoading: false,
      selectionData: [],
      toolBtnData: []
    }
  },
  created() {
    _this = this
    if (this.toolOptions && this.toolOptions.btns) {
      this.toolOptions.btns.forEach((it, i) => {
        if (it.btnType) {
          if (it.btnType === 'delete') {
            it.afterHandler = () => {
              _this.reloadTable()
            }
          }
        }
      })
    }
    this.tableOptions.where = this.tableOptions.where || _this.$set(this.tableOptions, 'where', {})
    this.queryOptions.cols.forEach(it => this.$set(_this.tableOptions.where, it.field, ''))
    this.tableOptions.cols.forEach(it => {
      if (it.type === 'switch') {
        it.change = (row) => {
          this.$request(this.handlerRequest(it, row, {
            id: row.id,
            [it.field]: row[it.field]
          }))
        }
      }
      if (it.type === 'btns') {
        it.btns.forEach(btn => {
          btn.click = (row) => {
            if (btn.btnType === 'delete') {
              this.$common.handleDelete({
                url: btn.request.url,
                id: row.id,
                done: () => this.reloadTable()
              })
            } else if (btn.btnType === 'update') {
              this.handleUpdate(row)
            }
          }
        })
      }
    })
  },
  methods: {
    selectionChange(columns) {
      if (this.toolOptions && this.toolOptions.btns) {
        this.toolOptions.btns.forEach((it, i) => { it && it.request && it.request.data && this.$set(this.toolBtnData, i, ({ ...it.request.data })) })
        this.toolBtnData.forEach((it, i) => Object.keys(it).filter(key => it[key] === 'rowField').forEach(key => { this.$set(this.toolBtnData[i], key, columns.map(it => it[key]).join(',')) }))
      }
    },
    handlerRequest(it, row, defaultData) {
      var requestOptions = {}
      requestOptions.url = it.request.url
      requestOptions.method = it.request.method || 'get'

      var requestData = {}
      if (!it.request.data && defaultData) {
        requestData = defaultData
      } else {
        requestData = it.request.data
        for (var d in it.request.data) {
          var value = requestData[d]
          if (value === 'rowField') {
            requestData[d] = row[d]
          }
        }
      }
      if (requestOptions.method === 'get') {
        requestOptions.params = requestData
      } else {
        requestOptions.data = requestData
      }
      return requestOptions
    },
    reloadTable() {
      this.$refs.table.reloadList()
    },
    handleCreate() {
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
    },
    handleUpdate(row) {
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['inputForm'].getDetail(row)
      })
    },
    handleDownload() {
      this.$common.exportExcel({
        url: this.tableOptions.url,
        headers: this.queryOptions.btns.filter(it => it.type === 'export')[0].headers,
        columns: this.queryOptions.btns.filter(it => it.type === 'export')[0].columns,
        where: this.tableOptions.where
      })
    }
  }
}
</script>

<style scoped>
  .tool-row {
    margin-bottom: 6px
  }
  .tool-row > div {
    display: inline-block;
    margin-left: 10px;
  }
</style>

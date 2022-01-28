<style>
.el-input-number .el-input__inner{
  text-align: left;
}
</style>

<template>
  <div class="app-container">

    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="机构搜索">
          <el-input v-model="searchValue" @input="searchOffice" placeholder="机构名称、链接、权限标识" style="width: 200px"></el-input>
        </el-form-item>
        <el-button class="filter-item" type="primary" icon="el-icon-search" @click="searchOffice">
          搜索
        </el-button>
        <el-button class="filter-item" icon="el-icon-delete" @click="() => { this.searchValue = ''; searchOffice() }">
          清空
        </el-button>
      </el-form>
    </div>

    <el-row style="margin-bottom: 5px">
      <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubOffice('0')">
        添加机构
      </el-button>
      <el-button type="primary" icon="el-icon-sort" plain @click="expand">展开/折叠</el-button>
    </el-row>

    <pd-table ref="table" v-bind="tableOptions" v-if="officeData && officeData.length > 0 && refreshTable" />

    <pd-dialog ref="officeFormDialog" width="1050px" :title="dialogTitle" @confirm-click="save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="right" label-width="80px" style="width: 900px; margin-left:50px;">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="机构类型" prop="type">
                <pd-select v-model="temp.type" type="office_type" width="100%" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="上级机构" prop="pid">
                <treeselect v-model="temp.pid" :options="officeTree" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="机构名称" prop="name">
                <el-input v-model="temp.name" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="机构编码" prop="code">
                <el-input v-model="temp.code" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="6">
              <el-form-item label="排序" prop="sort">
                <el-input-number v-model="temp.sort" controls-position="right" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </pd-dialog>

  </div>
</template>

<script>
import Treeselect from '@riophae/vue-treeselect'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'

export default {
  components: { Treeselect },
  data() {
    return {
      refreshTable: true,
      officeData: [],
      officeTree: [],
      searchValue: '',
      tableOptions: {
        el: {
          'default-expand-all': true,
          'tree-props': { children: 'children', hasChildren: 'hasChildren' },
          'row-key': 'id'
        },
        showNo: false,
        page: false,
        cols: [
          {
            field: 'name',
            title: '机构名称',
            align: 'left',
            type: 'html'
          },
          {
            field: 'code',
            title: '机构编码',
            width: 300,
            align: 'left',
            type: 'html'
          },
          {
            field: 'sort',
            title: '序号',
            width: 60
          },
          {
            title: '排序',
            type: 'btns',
            width: 150,
            btns: [
              {
                title: '上移',
                type: 'text',
                icon: 'el-icon-sort-up',
                click: (row) => {
                  this.$get('office/sort/up',{
                    id: row.id,
                    pid: row.pid,
                    sort: row.sort
                  }).then(() => {
                    this.reloadTable()
                  })
                }
              },
              {
                title: '下移',
                type: 'text',
                icon: 'el-icon-sort-down',
                click: (row) => {
                  this.$get('office/sort/down',{
                    id: row.id,
                    pid: row.pid,
                    sort: row.sort
                  }).then(() => {
                    this.reloadTable()
                  })
                }
              }
            ]
          },
          {
            title: '操作',
            type: 'btns',
            width: 260,
            fixed: 'right',
            align: 'left',
            btns: [
              {
                title: '添加下级机构',
                type: 'text',
                icon: 'el-icon-plus',
                click: (row) => {
                  this.addSubOffice(row.id)
                }
              },
              {
                title: '编辑',
                type: 'text',
                icon: 'el-icon-edit',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                title: '删除',
                type: 'text',
                icon: 'el-icon-delete',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'office/delete',
                    id: row.id,
                    done: () => this.reloadTable()
                  })
                }
              }
            ]
          }
        ]
      },
      dialogTitle: '',
      temp: this.getTemp(),
      rules: {
        type: [{ required: true, message: '请选择机构类型', trigger: 'change' }],
        pid: [{ required: true, message: '请选择上级机构', trigger: 'change' }],
        name: [{ required: true, message: '请输入机构名称', trigger: 'change' }],
        code: [{ required: true, message: '请输入机构编码', trigger: 'change' }]
      },
      searchTimeout: ''
    }
  },
  mounted() {
    this.reloadTable()
  },
  watch: {
    officeData() {
      this.officeTree = [{
        label: '根节点',
        id: '0',
        children: this.$treeTable.genTree(this.officeData)
      }]
    }
  },
  methods: {
    expand(){
      this.refreshTable = false
      this.tableOptions.el["default-expand-all"] = !this.tableOptions.el["default-expand-all"]
      this.$nextTick(() => {
        this.refreshTable = true
      })
    },
    searchOffice() {
      var _this = this
      clearTimeout(this.searchTimeout)
      this.searchTimeout = setTimeout(() => {
        if(_this.searchValue){
          _this.$set(_this.tableOptions, 'data', _this.$treeTable.recursionSearch(['name', 'code'], _this.$common.copyNew(_this.officeData), _this.searchValue))
        }else{
          _this.$set(_this.tableOptions, 'data', _this.officeData)
        }
      },1000)
    },
    getTemp() {
      return {
        id: '',
        name: '',
        sort: 0,
        pid: '',
        type: '',
        code: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    getSort() {
      this.$get('office/sort', { pid: this.temp.pid }).then(res => {
        this.temp.sort = res.data
      })
    },
    addSubOffice(id) {
      this.resetTemp()
      this.temp.pid = id
      this.temp.id = this.$common.uuid()
      this.getSort()
      this.dialogTitle = '添加'
      this.$refs.officeFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          if(this.temp.pid == this.temp.id){
            this.$notify({
              title: '失败',
              message: '上级机构不能选当前机构',
              type: 'error',
              duration: 2000
            })
            return
          }
          if(this.$treeTable.isChildren(this.$treeTable.queryChildren(this.officeData, this.temp.id), this.temp.pid)){
            this.$notify({
              title: '失败',
              message: '上级机构不能选当前机构子级',
              type: 'error',
              duration: 2000
            })
            return
          }
          this.$post('office/save', this.temp).then(() => {
            this.reloadTable()
            this.$refs.officeFormDialog.hide()
            this.$notify({
              title: '成功',
              message: dialogTitle + '成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    reloadTable() {
      this.$get('office/tree').then(res => {
        this.officeData = res.data.list
        this.$set(this.tableOptions, 'data', this.officeData)
      })
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      this.temp.name = this.temp.name.replaceAll(/<font.*?>(.*?)<\/font>/g,'$1')
      this.dialogTitle = '修改'
      this.$refs.officeFormDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}

</script>

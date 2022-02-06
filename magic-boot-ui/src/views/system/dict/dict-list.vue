<template>
  <div class="app-container">

    <mb-search :where="tableOptions.where" @search="reloadTable" />

    <el-row class="toolbar-container">
      <el-button v-permission="'dict:save'" class="filter-item" type="primary" icon="el-icon-edit" @click="handleCreate">
        添加
      </el-button>
    </el-row>

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="dictDialog" :title="dialogTitle" width="640px" @confirm-click="save($event)">
      <template #content>
        <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="80px">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="字典类型" prop="dictType">
                <mb-select v-model="temp.dictType" type="dict_type" width="185px" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="类型" prop="type">
                <el-input v-model="temp.type" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="排序" prop="sort">
                <el-input v-model="temp.sort" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="描述" prop="descRibe">
                <el-input v-model="temp.descRibe" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="备注" prop="remarks">
                <el-input v-model="temp.remarks" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </template>
    </mb-dialog>

    <mb-dialog ref="dictItemsDialog" title="字典项" width="1400px">
      <template #content>
        <dict-items :key="Math.random()" :dict-id.sync="dictId" />
      </template>
    </mb-dialog>

  </div>
</template>

<script>
import DictItems from './dict-items'

export default {
  name: 'DictList',
  components: {
    DictItems
  },
  data() {
    return {
      tableOptions: {
        url: 'dict/list',
        page: true,
        where: {
          type: {
            type: 'input',
            label: '类型',
            value: ''
          },
          dictType: {
            type: 'select',
            label: '字典类型',
            value: '',
            properties: {
              'all-option': true,
              type: 'dict_type'
            }
          }
        },
        cols: [
          {
            field: 'type',
            title: '类型'
          },
          {
            field: 'descRibe',
            title: '描述'
          },
          {
            field: 'dictType',
            title: '字典类型',
            width: 200,
            dictType: 'dict_type'
          },
          {
            field: 'remarks',
            title: '备注',
            width: 200
          },
          {
            field: 'sort',
            title: '排序',
            width: 100
          },
          {
            title: '操作',
            type: 'btns',
            width: 220,
            fixed: 'right',
            btns: [
              {
                permission: 'dict:save',
                title: '修改',
                type: 'text',
                icon: 'el-icon-edit',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'dict:delete',
                title: '删除',
                type: 'text',
                icon: 'el-icon-delete',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'dict/delete',
                    id: row.id,
                    done: () => {
                      this.reloadTable()
                      this.$common.getDictData()
                    }
                  })
                }
              },
              {
                permission: 'dict:items:view',
                title: '字典项',
                type: 'text',
                icon: 'el-icon-menu',
                click: (row) => {
                  this.$refs.dictItemsDialog.show()
                  this.dictId = row.id
                }
              }
            ]
          }
        ]
      },
      dictId: '',
      temp: this.getTemp(),
      dialogTitle: '',
      rules: {
        dictType: [{ required: true, message: '请输入标签', trigger: 'change' }],
        type: [{ required: true, message: '请输入类型', trigger: 'change' }],
        sort: [{ required: true, message: '请输入排序', trigger: 'change' }],
        descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]
      }
    }
  },
  methods: {
    getTemp() {
      return {
        id: '',
        dictType: '',
        type: '',
        sort: 0,
        descRibe: '',
        remarks: ''
      }
    },
    reloadTable() {
      this.$refs.table.reloadList()
    },
    getSort() {
      this.$get('dict/sort').then(res => {
        this.temp.sort = res.data
      })
    },
    handleCreate() {
      this.temp = this.getTemp()
      this.getSort()
      this.dialogTitle = '添加'
      this.$refs.dictDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save(d) {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          d.loading()
          this.$post('dict/save', this.temp).then((response) => {
            d.hideLoading()
            this.temp.id = response.data
            this.$refs.dictDialog.hide()
            this.$notify({
              title: '成功',
              message: this.dialogTitle + '成功',
              type: 'success',
              duration: 2000
            })
            this.reloadTable()
            this.$common.getDictData()
          }).catch(() => d.hideLoading())
        }
      })
    },
    handleUpdate(row) {
      this.$common.objAssign(this.temp, row)
      this.dialogTitle = '修改'
      this.$refs.dictDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}
</script>

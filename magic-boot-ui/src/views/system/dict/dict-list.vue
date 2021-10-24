<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="类型">
          <el-input v-model="tableOptions.where.type" placeholder="请输入类型" style="width: 200px;" class="filter-item" />
        </el-form-item>
        <el-form-item label="字典类型">
          <pd-select v-model="tableOptions.where.dictType" :all-option="true" type="dict_type" width="185px" />
        </el-form-item>
        <el-button class="filter-item" type="primary" icon="el-icon-search" @click="reloadTable">
          搜索
        </el-button>
        <el-button v-permission="'dict:save'" class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
      </el-form>
    </div>

    <pd-table ref="table" v-bind="tableOptions" />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible" :close-on-click-modal="false" width="700px">
      <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="100px" style="margin-left: 20px">
        <el-form-item label="字典类型" prop="dictType">
          <pd-select v-model="temp.dictType" type="dict_type" width="185px" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-input v-model="temp.type" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input v-model="temp.sort" />
        </el-form-item>
        <el-form-item label="描述" prop="descRibe">
          <el-input v-model="temp.descRibe" />
        </el-form-item>
        <el-form-item label="备注" prop="remarks">
          <el-input v-model="temp.remarks" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">
          关闭
        </el-button>
        <el-button type="primary" @click="save()">
          确认
        </el-button>
      </div>
    </el-dialog>

    <el-dialog v-el-drag-dialog title="字典项" :visible.sync="dictItemsVisible" :close-on-click-modal="false" width="1400px">
      <dict-items :dict-id.sync="dictId" />
    </el-dialog>

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
          username: '',
          name: ''
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
            width: 300,
            fixed: 'right',
            btns: [
              {
                permission: 'dict:save',
                title: '修改',
                type: 'primary',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'dict:delete',
                title: '删除',
                type: 'danger',
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
                permission: 'dict:items',
                title: '字典项',
                type: 'primary',
                click: (row) => {
                  this.dictItemsVisible = true
                  this.dictId = row.id
                }
              }
            ]
          }
        ]
      },
      dictId: '',
      temp: this.getTemp(),
      dialogFormVisible: false,
      dictItemsVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      pvData: [],
      rules: {
        dictType: [{ required: true, message: '请输入标签', trigger: 'change' }],
        type: [{ required: true, message: '请输入类型', trigger: 'change' }],
        sort: [{ required: true, message: '请输入排序', trigger: 'change' }],
        descRibe: [{ required: true, message: '请输入描述', trigger: 'change' }]
      },
      downloadLoading: false
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
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('dict/save', this.temp).then((response) => {
            this.temp.id = response.data
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: (this.dialogStatus === 'create' ? '创建' : '修改') + '成功',
              type: 'success',
              duration: 2000
            })
            this.reloadTable()
            this.$common.getDictData()
          })
        }
      })
    },
    handleUpdate(row) {
      this.$common.objAssign(this.temp, row)
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}
</script>

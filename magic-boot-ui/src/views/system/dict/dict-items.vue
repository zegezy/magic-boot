<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-form-item label="标签">
          <el-input v-model="tableOptions.where.label" placeholder="标签" style="width: 200px;" class="filter-item" />
        </el-form-item>
        <el-form-item label="值">
          <el-input v-model="tableOptions.where.value" placeholder="值" style="width: 200px;" class="filter-item" />
        </el-form-item>
        <el-button class="filter-item" type="primary" icon="el-icon-search" @click="reloadTable">
          搜索
        </el-button>
        <el-button v-permission="'dict:items:save'" class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
      </el-form>
    </div>

    <pd-table ref="table" v-bind="tableOptions" />

    <el-dialog v-el-drag-dialog :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible" :modal="false" :close-on-click-modal="false" width="700px">
      <el-form ref="dataForm" :inline="true" :rules="rules" :model="temp" label-position="right" label-width="100px" style="margin-left: 20px">
        <el-form-item label="标签名" prop="label">
          <el-input v-model="temp.label" />
        </el-form-item>
        <el-form-item label="值" prop="value">
          <el-input v-model="temp.value" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input v-model="temp.sort" />
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

  </div>
</template>

<script>

export default {
  name: 'DictItems',
  props: {
    dictId: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      tableOptions: {
        url: 'dict/items/list',
        page: true,
        where: {
          label: '',
          value: ''
        },
        cols: [
          {
            field: 'label',
            title: '类型'
          },
          {
            field: 'value',
            title: '值'
          },
          {
            field: 'sort',
            title: '排序'
          },
          {
            field: 'remarks',
            title: '备注'
          },
          {
            title: '操作',
            type: 'btns',
            fixed: 'right',
            btns: [
              {
                permission: 'dict:items:save',
                title: '修改',
                type: 'primary',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                permission: 'dict:items:delete',
                title: '删除',
                type: 'danger',
                click: (row) => {
                  this.$common.handleDelete({
                    url: 'dict/items/delete',
                    id: row.id,
                    done: () => {
                      this.reloadTable()
                      this.$common.getDictData()
                    }
                  })
                }
              }
            ]
          }
        ]
      },
      textMap: {
        update: '修改',
        create: '添加'
      },
      dialogFormVisible: false,
      dialogStatus: '',
      rules: {
        value: [{ required: true, message: '请输入值', trigger: 'change' }],
        label: [{ required: true, message: '请输入标签名', trigger: 'change' }],
        sort: [{ required: true, message: '请输入排序', trigger: 'change' }]
      },
      temp: this.getTemp()
    }
  },
  watch: {
    dictId(newVal) {
      this.dictId = newVal
      this.reloadTable()
    }
  },
  mounted() {
    this.selectValue = this.value
    this.reloadTable()
  },
  methods: {
    reloadTable() {
      this.tableOptions.where.dictId = this.dictId
      this.$refs.table.reloadList()
    },
    getTemp() {
      return {
        id: '',
        value: '',
        label: '',
        dictId: this.dictId,
        sort: 0,
        remarks: ''
      }
    },
    getSort() {
      this.$get('dict/items/sort', { dictId: this.dictId }).then(res => {
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
          this.$post('dict/items/save', this.temp).then(() => {
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

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

    <mb-table ref="table" v-bind="tableOptions" />

    <mb-dialog ref="formDialog" :title="dialogTitle" width="700px" @confirm-click="save">
      <template #content>
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
      </template>
    </mb-dialog>

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
      dialogTitle: '',
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
      this.dialogTitle = '添加'
      this.$refs.formDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('dict/items/save', this.temp).then(() => {
            this.$refs.formDialog.hide()
            this.$notify({
              title: '成功',
              message: this.dialogTitle + '成功',
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
      this.dialogTitle = '修改'
      this.$refs.formDialog.show()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}

</script>

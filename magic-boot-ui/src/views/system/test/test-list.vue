<template>
  <div class="app-container">
    <div class="filter-container">
      <el-form :inline="true">
        <el-button class="filter-item" style="margin-left: 10px;" type="primary" icon="el-icon-edit" @click="handleCreate">
          添加
        </el-button>
      </el-form>
    </div>

    <mb-table ref="table" v-bind="tableOptions" />

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible" :close-on-click-modal="false" width="700px">
      <el-form ref="dataForm" :inline="true" :model="temp" label-position="right" label-width="100px" style="margin-left: 20px">
        <el-form-item label="name" prop="name">
          <el-input v-model="temp.name" />
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
  name: 'TestList',
  data() {
    return {
      tableOptions: {
        url: 'test/list',
        page: true,
        cols: [
          {
            field: 'name',
            title: 'name'
          },
        ]
      },
      temp: this.getTemp(),
      dialogFormVisible: false,
      dictItemsVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      downloadLoading: false
    }
  },
  methods: {
    getTemp() {
      return {
        name: ''
      }
    },
    reloadTable() {
      this.$refs.table.reloadList()
    },
    handleCreate() {
      this.temp = this.getTemp()
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('test/save', this.temp).then((response) => {
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: (this.dialogStatus === 'create' ? '创建' : '修改') + '成功',
              type: 'success',
              duration: 2000
            })
            this.reloadTable()
          })
        }
      })
    }
  }
}
</script>

<template>
  <div class="app-container">

    <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubMenu('0')">
      添加组织机构
    </el-button>

    <pd-table ref="table" v-bind="tableOptions" />

    <pd-dialog :visible.sync="dialogFormVisible" width="600px" @confirm-click="$refs.dataForm.save()">
      <template #content>
        <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="100px" style="width: 400px; margin-left:50px;">
          <el-form-item label="名称" prop="name">
            <el-input v-model="temp.name" />
          </el-form-item>
          <el-form-item label="类型" prop="type">
            <pd-select v-model="temp.type" type="office_type" width="100%" />
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model="temp.sort" />
          </el-form-item>
        </el-form>
      </template>
    </pd-dialog>

  </div>
</template>

<script>

export default {
  data() {
    return {
      tableOptions: {
        el: {
          'default-expand-all': true,
          'tree-props': { children: 'children' },
          'row-key': 'id'
        },
        showNo: false,
        data: [],
        updateStr: '',
        cols: [
          {
            field: 'name',
            title: '名称',
            width: '400',
            align: 'left'
          },
          {
            field: 'type',
            title: '类型',
            dictType: 'office_type',
            width: '250',
            align: 'left'
          },
          {
            field: 'sort',
            title: '排序',
            width: 60
          },
          {
            title: '操作',
            type: 'btns',
            fixed: 'right',
            align: 'left',
            btns: [
              {
                title: '添加下级',
                type: 'primary',
                click: (row) => {
                  this.addSubMenu(row.id)
                }
              },
              {
                title: '编辑',
                type: 'primary',
                click: (row) => {
                  this.handleUpdate(row)
                }
              },
              {
                title: '删除',
                type: 'danger',
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
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      temp: this.getTemp(),
      rules: {
        name: [{ required: true, message: '请输入名称', trigger: 'change' }],
        type: [{ required: true, message: '请选择类型', trigger: 'change' }]
      }
    }
  },
  created() {
    this.reloadTable()
  },
  methods: {
    getTemp() {
      return {
        id: '',
        name: '',
        type: '',
        sort: 0,
        pid: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    addSubMenu(id) {
      this.resetTemp()
      this.temp.pid = id
      this.dialogStatus = 'create'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post('office/save', this.temp).then(() => {
            this.reloadTable()
            this.dialogFormVisible = false
            this.$notify({
              title: '成功',
              message: (this.dialogStatus === 'create' ? '创建' : '修改') + '成功',
              type: 'success',
              duration: 2000
            })
          })
        }
      })
    },
    reloadTable() {
      this.$get('office/list').then(res => {
        this.$set(this.tableOptions, 'data', this.$common.handlerTreeData(res.data, 'id', 'pid', 'sort', '0'))
      })
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        this.temp[t] = row[t]
      }
      this.dialogStatus = 'update'
      this.dialogFormVisible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  }
}

</script>

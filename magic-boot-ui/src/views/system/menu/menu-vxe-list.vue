<template>
  <div class="app-container">

    <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubMenu('0')">
      添加菜单
    </el-button>

    <vxe-grid v-bind="gridOptions" @form-submit="findList"></vxe-grid>

    <el-dialog :title="textMap[dialogStatus]" :visible.sync="dialogFormVisible" :close-on-click-modal="false">
      <el-form ref="dataForm" :rules="rules" :model="temp" label-position="left" label-width="100px" style="width: 400px; margin-left:50px;">
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="temp.name" />
        </el-form-item>
        <el-form-item label="菜单链接" prop="url">
          <el-input v-model="temp.url" />
        </el-form-item>
        <el-form-item label="权限标识" prop="permission">
          <el-input v-model="temp.permission" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input v-model="temp.sort" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="temp.descRibe" :autosize="{ minRows: 4, maxRows: 6}" type="textarea" />
        </el-form-item>
        <el-form-item label="是否显示">
          <el-checkbox v-model="temp.isShow">显示</el-checkbox>
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
  data() {
    return {
      gridOptions: {
        resizable: true,
        border: true,
        showOverflow: true,
        loading: false,
        height: 400,
        exportConfig: {},
        formConfig: {
          data: {
            name: '',
            sex: ''
          },
          items: [
            { field: 'name', title: '菜单名称', itemRender: { name: '$input', props: { placeholder: '请输入名称' } } },
            { field: 'url', title: '路径', titlePrefix: { message: '输入存在的路径', icon: 'fa fa-info-circle' }, itemRender: { name: '$input', pops: { placeholder: '请输入名称' } } },
            { itemRender: { name: '$buttons', children: [{ props: { type: 'submit', content: '查询', status: 'primary' } }, { props: { type: 'reset', content: '重置' } }] } }
          ]
        },
        toolbarConfig: {
          export: true,
          custom: true
        },
        columns: [
          { type: 'seq', width: 60 },
          { type: 'checkbox', width: 60 },
          { field: 'name', title: '菜单名称' , showOverflow: true },
          { field: 'url', title: '路径' , showOverflow: true },
          { field: 'permission', title: '权限标识' },
          { field: 'sort', title: '排序' },
          { field: 'isShow', title: '是否显示' },
          { title: '操作' }
        ],
        data: []
      },
      dialogFormVisible: false,
      dialogStatus: '',
      textMap: {
        update: '修改',
        create: '添加'
      },
      temp: this.getTemp(),
      listConfigDialogVisible: false,
      formConfigDialogVisible: false,
      rules: {
        name: [{ required: true, message: '请输入菜单名称', trigger: 'change' }]
      }
    }
  },
  methods: {
    getTemp() {
      return {
        id: '',
        name: '',
        url: '',
        permission: '',
        sort: 0,
        descRibe: '',
        isShow: true,
        pid: ''
      }
    },
    resetTemp() {
      this.temp = this.getTemp()
    },
    getSort() {
      this.$get('menu/sort', { pid: this.temp.pid }).then(res => {
        this.temp.sort = res.data
      })
    },
    addSubMenu(id) {
      this.resetTemp()
      this.temp.pid = id
      this.temp.id = this.$common.uuid()
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
          this.temp.isShow = this.temp.isShow === true ? 1 : 0
          this.$post('menu/save', this.temp).then(() => {
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
      this.$refs.table.reloadList()
    },
    handleUpdate(row) {
      for (var t in this.temp) {
        if (t === 'isShow') {
          if (row[t] === 1) {
            this.temp[t] = true
          } else {
            this.temp[t] = false
          }
        } else {
          this.temp[t] = row[t]
        }
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

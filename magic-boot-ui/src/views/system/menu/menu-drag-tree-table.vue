<template>
  <div class="app-container">

    <el-button class="filter-item" style="margin-bottom:10px;" type="primary" icon="el-icon-edit" @click="addSubMenu('0')">
      添加菜单
    </el-button>

    <dragTreeTable
      :data="treeData"
      :onDrag="onTreeDataChange"
      fixed
      height="100%"
      border>
    </dragTreeTable>
<!--    <el-tree :data="menuTreeList"-->
<!--             :props="defaultProps"-->
<!--             node-key="id"-->
<!--             :default-expanded-keys="menuTreeExpandedList"-->
<!--             draggable>-->
<!--      <span class="custom-tree-node" slot-scope="{ node, data }">-->
<!--        <span>{{ node.label }}</span>-->
<!--        <span>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            style="width: 270px;text-align: left;color: #5a5e66;"-->
<!--            @click="() => append(data)">-->
<!--            {{ data.url }}-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            style="width: 100px;text-align: left;color: #5a5e66;"-->
<!--            @click="() => append(data)">-->
<!--            {{ data.permission }}-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            style="width: 100px;text-align: left;color: #5a5e66;"-->
<!--            @click="() => append(data)">-->
<!--            {{ data.sort }}-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            style="width: 100px;text-align: left;color: #5a5e66;"-->
<!--            @click="() => append(data)">-->
<!--            {{ data.isShow }}-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            @click="() => append(data)">-->
<!--            添加下级菜单-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            @click="() => remove(node, data)">-->
<!--            编辑-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            type="text"-->
<!--            size="mini"-->
<!--            @click="() => remove(node, data)">-->
<!--            删除-->
<!--          </el-button>-->
<!--        </span>-->
<!--      </span>-->
<!--    </el-tree>-->

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
import dragTreeTable from "drag-tree-table";
export default {
  data() {
    return {
      treeData: {
        custom_field: {
          id: 'id',
          order: 'sort',
          lists: 'children',
          parent_id: 'parent_id'
        },
        columns: [
          {
            type: 'selection',
            title: '菜单名称',
            field: 'name',
            width: 200,
            align: 'left',
            formatter: (item) => {
              return '<a>'+item.name+'</a>'
            }
          },
          {
            type: 'selection',
            title: '路径',
            field: 'url',
            width: 200,
            align: 'left',
          },
          {
            type: 'selection',
            title: '权限标识',
            field: 'permission',
            width: 200,
            align: 'left',
          },
          {
            type: 'selection',
            title: '排序',
            field: 'sort',
            width: 200,
            align: 'left',
          },
          {
            type: 'selection',
            title: '是否显示',
            field: 'isShow',
            width: 200,
            align: 'left',
          },
          {
            title: '操作',
            type: 'action',
            width: 350,
            align: 'center',
            actions: [
              {
                text: '添加下级菜单',
                onclick: (item) => {
                  // item是当前行的数据
                  console.log(item)
                },
                formatter: (item) => {
                  return '<i>查看角色</i>'
                }
              },
              {
                text: '编辑',
                onclick: (item) => {
                  // item是当前行的数据
                  console.log(item)
                },
                formatter: (item) => {
                  return '<i>编辑</i>'
                }
              },
              {
                text: '删除',
                onclick: (item) => {
                  // item是当前行的数据
                  console.log(item)
                },
                formatter: (item) => {
                  return '<i>编辑</i>'
                }
              }
            ]
          },
        ],
        lists: []
      },
      menuTreeExpandedList:[],
      menuTreeList:[],
      defaultProps: {
        children: 'children',
        label: 'name'
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
  components: {
    dragTreeTable
  },
  created(){
    this.getMenuTreeList();
  },
  methods: {
    onTreeDataChange(list) {
      this.treeData.lists = list;
    },
    getMenuTreeList(){
      this.$get('menu/tree', { pid: this.temp.pid }).then(res => {
        this.menuTreeList = res.data.list
        this.menuTreeExpandedList = this.getMenuId(this.menuTreeList);
        this.treeData.lists = res.data.list
        console.log(this.menuTreeList)
        console.log(this.menuTreeExpandedList)
      })
    },
    getMenuId(menuArr){
      let idArr = [];
      if (menuArr != null && menuArr.length > 0){
        for (let i = 0; i < menuArr.length; i++) {
          idArr.push(menuArr[i].id);
          idArr.push(...this.getMenuId(menuArr[i].children));
        }
      }
      return idArr;
    },
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

<style>
.custom-tree-node {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  padding-right: 8px;
}
</style>

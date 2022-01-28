<template>
  <el-form
    ref="dataForm"
    :rules="rules"
    :model="temp"
    v-bind="form.el"
    :label-position="form.el.labelPosition === undefined ? 'right' : form.el.labelPosition"
    :label-width="form.el.labelWidth === undefined ? '120px' : form.el.labelWidth"
    :style="form.el.style === undefined ? '' : form.el.style"
  >
    <el-row v-for="(row,i) in form.rows" :key="i" :gutter="row.gutter">
      <el-col v-for="(col,j) in row.cols" :key="j" :span="col.span" v-bind="col.colEl">
        <el-form-item :label="col.label" :label-width="col.labelWidth" :prop="col.name" v-bind="col.formItemEl">
          <el-switch
            v-if="col.type === 'switch'"
            v-model="temp[col.name]"
            :active-value="col.activeValue"
            :inactive-value="col.inactiveValue"
          />
          <el-checkbox-group v-else-if="col.type === 'checkboxGroup'" v-model="temp[col.name]" size="small">
            <el-checkbox v-for="checkboxIt in temp['_'+col.name]" :key="checkboxIt[col.defaultValue.value]" :label="checkboxIt[col.defaultValue.value]">{{ checkboxIt[col.defaultValue.text] }}</el-checkbox>
          </el-checkbox-group>
          <mb-select v-else-if="col.type === 'select'" v-model="temp[col.name]" v-bind="col.el" />
          <el-input v-else v-model="temp[col.name]" :type="col.type" :value="col.defaultValue" />
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>

export default {
  name: 'CommonForm',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    form: {
      type: Object,
      default: () => {}
    },
    detail: {
      type: Object,
      default: () => {}
    },
    params: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      rules: {
      },
      temp: this.getTemp()
    }
  },
  computed: {
    dialogVisible: {
      get() {
        return this.visible
      },
      set(val) {
        this.$emit('update:visible', val)
      }
    }
  },
  watch: {
    visible(newVal) {
      this.temp = this.getTemp()
      this.$nextTick(() => {
        this.$refs['dataForm'].clearValidate()
      })
    }
  },
  created() {
    this.form.el = this.form.el || {}
    this.form.rows.forEach(row => {
      row.cols.forEach(col => {
        if (col.rule) {
          this.$set(this.rules, col.name, col.rule)
        }
      })
    })
  },
  methods: {
    getTemp() {
      var _temp = {}
      this.form.rows.forEach(row => {
        row.cols.forEach(col => {
          if (col.type === 'checkboxGroup') {
            _temp[col.name] = []
            this.$request({
              url: col.defaultValue.request.url,
              method: col.defaultValue.request.method
            }).then(res => {
              const { data } = res
              this.$set(this.temp, '_' + col.name, data)
            })
          } else {
            _temp[col.name] = col.defaultValue || ''
          }
        })
      })
      return _temp
    },
    save() {
      this.$refs['dataForm'].validate((valid) => {
        if (valid) {
          this.$post(this.form.request.url, this.temp).then(res => {
            this.dialogVisible = false
            this.$notify({
              title: '成功',
              message: (!this.temp.id ? '创建' : '修改') + '成功',
              type: 'success',
              duration: 2000
            })
            this.$emit('reload-table')
          })
        }
      })
    },
    getDetail(row) {
      this.temp.id = row.id
      this.$get(this.detail.request.url, { id: row.id }).then(res => {
        const { data } = res
        for (var t in this.temp) {
          if (data[t] && (!this.detail.excludeAssign || this.detail.excludeAssign.indexOf(t) === -1)) {
            this.$set(this.temp, t, data[t])
          }
        }
      })
    }
  }
}
</script>

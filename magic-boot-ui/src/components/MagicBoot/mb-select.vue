<template>
  <div>
    <el-select v-if="mbType === 'select'" v-model="selectValue" v-bind="el" :style="{ width }" :placeholder="placeholder || '请选择'" filterable clearable>
      <el-option
        v-for="item in selectList"
        :key="item.value"
        :label="item.label"
        :value="item.value"
      />
    </el-select>
    <el-radio-group v-if="mbType === 'radio'" v-model="selectValue">
      <el-radio v-for="item in selectList" :key="item.value" :label="item.value">
        {{ item.label }}
      </el-radio>
    </el-radio-group>
  </div>
</template>

<script>

export default {
  name: 'MbSelect',
  model: {
    prop: 'value',
    event: 'change'
  },
  props: {
    data: {
      type: Array,
      default: () => []
    },
    type: {
      type: String,
      default: ''
    },
    // eslint-disable-next-line vue/require-prop-types
    value: {
      required: true
    },
    width: {
      type: String,
      default: '100%'
    },
    allOption: {
      type: Boolean,
      default: false
    },
    url: {
      type: String,
      default: ''
    },
    params: {
      type: Object,
      default: () => {}
    },
    labelField: {
      type: String,
      default: 'label'
    },
    valueField: {
      type: String,
      default: 'value'
    },
    mbType: {
      type: String,
      default: 'select'
    },
    el: {
      type: Object,
      default: () => {}
    },
    placeholder: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      selectList: [],
      selectValue: ''
    }
  },
  watch: {
    type(newVal) {
      if (this.value instanceof Array || this.value.toString().indexOf(',') !== -1) {
        this.selectValue = []
      } else {
        this.selectValue = ''
      }
      this.loadData()
    },
    value(value) {
      this.loadData()
    },
    selectValue(value) {
      if (this.el && this.el.multiple && value.length > 0) {
        value = value.join(',')
      }
      this.$emit('update:value', value)
      this.$emit('change', value)
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    async loadData() {
      if (this.value || this.value == '') {
        if ((!(this.value instanceof Array) && this.value.toString().indexOf(',') !== -1)) {
          this.selectValue = this.value.split(',')
        } else {
          if (this.el && this.el.multiple && !(this.value instanceof Array)) {
            this.selectValue = [this.value]
          } else {
            this.selectValue = this.value
          }
        }
      } else {
        if (this.el && this.el.multiple) {
          this.selectValue = []
        }
      }
      if (this.data && this.data.length > 0) {
        this.listConcat(this.handlerData(this.data))
      } else if (this.url) {
        this.$get(this.url, this.params).then(res => {
          this.listConcat(this.handlerData(res.data.list))
        })
      } else {
        this.listConcat(this.$common.getDictType(this.type))
      }
    },
    listConcat(dictData) {
      if (this.allOption) {
        this.selectList = [{
          value: '',
          label: '全部'
        }]
        this.selectList = this.selectList.concat(dictData)
      } else {
        this.selectList = dictData
      }
    },
    handlerData(data) {
      var newData = []
      data.forEach(it => {
        newData.push({
          label: it[this.labelField],
          value: it[this.valueField].toString()
        })
      })
      return newData
    }
  }
}

</script>

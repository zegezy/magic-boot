<template>
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
</template>

<script setup>

import { ref, watch, onMounted, getCurrentInstance } from 'vue'

const { proxy } = getCurrentInstance()

const emit = defineEmits(['update:modelValue', 'change'])

const props = defineProps({
  data: {
    type: Array,
    default: () => []
  },
  type: {
    type: String,
    default: ''
  },
  // eslint-disable-next-line vue/require-prop-types
  modelValue: {
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
})

const selectList = ref([])
const selectValue = ref('')

watch(() => props.type, () => {
  if (props.modelValue instanceof Array || props.modelValue.toString().indexOf(',') !== -1) {
    selectValue.value = []
  } else {
    selectValue.value = ''
  }
  loadData()
})

watch(() => props.modelValue, () => {
  loadData()
})

watch(selectValue, (value) => {
  if (props.el && props.el.multiple && value.length > 0) {
    value = value.join(',')
  }
  emit('update:modelValue', value)
  emit('change', value)
})

onMounted(() => {
  loadData()
})

async function loadData() {
  if (props.modelValue || props.modelValue == '') {
    if ((!(props.modelValue instanceof Array) && props.modelValue.toString().indexOf(',') !== -1)) {
      selectValue.value = props.modelValue.split(',')
    } else {
      if (props.el && props.el.multiple && !(props.modelValue instanceof Array)) {
        selectValue.value = [props.modelValue]
      } else {
        selectValue.value = props.modelValue
      }
    }
  } else {
    if (props.el && props.el.multiple) {
      selectValue.value = []
    }
  }
  if (props.data && props.data.length > 0) {
    listConcat(handlerData(props.data))
  } else if (props.url) {
    proxy.$get(props.url, props.params).then(res => {
      listConcat(handlerData(res.data))
    })
  } else {
    listConcat(proxy.$common.getDictType(props.type))
  }
}

function listConcat(dictData) {
  if (props.allOption) {
    selectList.value = [{
      value: '',
      label: '全部'
    }]
    selectList.value = selectList.value.concat(dictData)
  } else {
    selectList.value = dictData
  }
}

function handlerData(data) {
  var newData = []
  data.forEach(it => {
    newData.push({
      label: it[props.labelField],
      value: it[props.valueField].toString()
    })
  })
  return newData
}

</script>

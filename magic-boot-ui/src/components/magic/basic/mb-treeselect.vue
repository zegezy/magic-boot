<template>
  <treeselect v-model="modelValue" :options="options" :key="modelValue" :placeholder="placeholder || (label && '请选择' + label)" :show-count="true" v-bind="props.props" />
</template>

<script setup>
  import { ref, getCurrentInstance } from "vue";
  const { proxy } = getCurrentInstance()
  const props = defineProps({
    modelValue: {
      type: String,
      default: null
    },
    url: {
      type: String,
      default: '',
      required: true
    },
    label: String,
    placeholder: String,
    props: Object
  })

  const options = ref([])

  proxy.$get(props.url).then(res => {
    options.value = res.data.list
    proxy.$treeTable.deleteEmptyChildren(options.value)
  })

</script>

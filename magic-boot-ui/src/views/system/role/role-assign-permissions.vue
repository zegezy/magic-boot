<template>
  <mb-tree ref="tree" :el="{ 'show-checkbox': true }" url="menu/tree" :search="true" search-width="230px" v-model:select-values="menus" />
</template>

<script setup>
import {getCurrentInstance, ref, defineExpose} from 'vue'
const { proxy } = getCurrentInstance()
const emit = defineEmits(['close'])
const props = defineProps({
  id: {
    type: String,
    default: ''
  }
})

console.log(props.id)

const menus = ref('')

proxy.$get('menu/by/role',{ roleId: props.id }).then(res => {
  menus.value = res.data.join(',')
})

function save(d) {
  d.loading()
  proxy.$post('role/save', {
    id: props.id,
    menus: menus.value
  }).then((response) => {
    d.hideLoading()
    proxy.$notify({
      title: '成功',
      message: '分配成功',
      type: 'success',
      duration: 2000
    })
    emit('close')
  }).catch(() => d.hideLoading())
}

defineExpose({ save })

</script>

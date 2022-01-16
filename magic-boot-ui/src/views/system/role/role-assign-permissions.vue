<template>
  <pd-tree ref="tree" :el="{ 'show-checkbox': true }" url="menu/tree" :search="true" search-width="230px" :select-values.sync="menus" />
</template>

<script>

export default {
  name: 'RoleAssignPermissions',
  props: {
    id: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      menus: ''
    }
  },
  created() {
    this.$get('menu/by/role',{ roleId: this.id }).then(res => {
      this.menus = res.data.join(',')
    })
  },
  methods: {
    save() {
      this.$post('role/save', {
        id: this.id,
        menus: this.menus
      }).then((response) => {
        this.$notify({
          title: '成功',
          message: '分配成功',
          type: 'success',
          duration: 2000
        })
        this.$emit('close')
      })
    }
  }
}
</script>

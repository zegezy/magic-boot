<template>
  <div>
    <el-select v-for="(data, i) in dataList" :key="i" v-model="dataValues[i]" :placeholder="'请选择' + (i+1) + '级'" @change="selectChange">
      <el-option
        v-for="item in data"
        :key="item.id"
        :label="item.name"
        :value="item.id"
      />
    </el-select>
  </div>
</template>

<script>
export default {
  name: 'ThreeLinkAge',
  data() {
    return {
      dataList: [[], [], []],
      dataValues: [],
      threeLinkageData: []
    }
  },
  created() {
    this.threeLinkageData = require('../../json/three-linkage.json')
    this.$set(this.dataList, 0, this.threeLinkageData.filter(it => it.level === 0))
  },
  methods: {
    selectChange(id) {
      var currLevel = this.threeLinkageData.filter(it => it.id === id).map(it => it.level)[0]
      this.dataList.forEach((it, i) => {
        if (i > currLevel) {
          this.$set(this.dataList, i, [])
          this.$set(this.dataValues, i, '')
        }
      })
      if (currLevel + 1 !== this.dataList.length) {
        this.$set(this.dataList, currLevel + 1, this.threeLinkageData.filter(it => it.pid == id))
      }
    }
  }
}
</script>


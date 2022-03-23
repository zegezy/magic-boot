<template>
  <el-tabs v-model="activeName" @tab-click="handleClick">
    <el-tab-pane label="基本信息" name="basic">
      <el-row :gutter="24">
        <el-col :span="24">
          <el-form-item label="分组名称">
            <el-input v-model="formData.groupName"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-tab-pane>
    <el-tab-pane label="字段信息" name="field">

    </el-tab-pane>
    <el-tab-pane label="生成信息" name="gen">

    </el-tab-pane>
  </el-tabs>
</template>

<script setup>
  import {reactive, ref} from 'vue'
  const activeName = ref('basic')
  const formData = reactive({
    groupName: ''
  })
</script>

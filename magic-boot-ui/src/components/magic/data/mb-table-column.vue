<template>
  <el-table-column
    v-bind="col.props"
    :key="col.field"
    :label="col.label"
    :prop="col.field"
    :align="col.align || 'center'"
    :width="col.width"
    :fixed="col.fixed"
    :sortable="col.sortable"
  >
    <template v-if="!col.cols" #default="scope">
      <span v-if="col.templet" v-html="col.templet(scope.row)" />
      <span v-else-if="col.dictType">
        {{ $common.getDictLabel(col.dictType, scope.row[col.field] + '') }}
      </span>
      <slot v-else-if="col.type == 'dynamic'" :name="col.field" :row="scope.row" :index="scope.$index" />
      <div v-else-if="col.type == 'switch'">
        <el-switch
            v-if="col.if === undefined ? true : col.if(scope.row)"
            v-model="scope.row[col.field]"
            :active-value="col.activeValue || 1"
            :inactive-value="col.inactiveValue || 0"
            @change="col.change(scope.row)"
        />
      </div>
      <div v-else-if="col.type == 'btns'">
        <template v-for="btn in col.btns">
          <el-button v-if="btn.if === undefined ? true : btn.if(scope.row)" :icon="btn.icon" :key="btn.label" v-permission="btn.permission" :type="btn.type" :link="btn.link" :size="btn.size || 'small'" :class="btn.class" @click="btn.click(scope.row, scope.$index)">
            {{ btn.label }}
          </el-button>
        </template>
      </div>
      <el-image
        v-else-if="col.type === 'image'"
        :src="scope.row[col.field].startsWith('http') ? scope.row[col.field] : $global.baseApi + scope.row[col.field]"
        :preview-src-list="[scope.row[col.field].startsWith('http') ? scope.row[col.field] : $global.baseApi + scope.row[col.field]]"
      />
      <span v-else-if="col.type === 'html'" v-html="scope.row[col.field]"></span>
      <span v-else-if="col.click">
        <a style="color: blue" @click="col.click(scope.row)">{{ scope.row[col.field] }}</a>
      </span>
      <span v-else-if="col.field">{{ scope.row[col.field] }}</span>
    </template>
    <mb-table-column v-for="(col2, j) in col.cols" :key="j" :col="col2">
      <template v-for="(value, key) in $slots" #[key]="{ row, index }">
        <slot :row="row" :index="index" :name="key" />
      </template>
    </mb-table-column>
  </el-table-column>
</template>

<script setup>
  defineProps({
    col: Object
  })
</script>

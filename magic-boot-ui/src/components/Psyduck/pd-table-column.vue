<template>
  <el-table-column
    :key="col.field"
    :label="col.title"
    :prop="col.field"
    :align="col.align || 'center'"
    :width="col.width"
    :fixed="col.fixed"
    :sortable="col.sortable"
  >
    <template v-if="!col.cols" slot-scope="scope">
      <span v-if="col.templet" v-html="col.templet(scope.row)" />
      <span v-else-if="col.dictType">
        {{ $common.getDictLabel(col.dictType, scope.row[col.field] + '') }}
      </span>
      <slot v-else-if="col.type == 'dynamic'" :name="col.field" :row="scope.row" :index="scope.$index" />
      <el-switch
        v-else-if="col.type == 'switch'"
        v-model="scope.row[col.field]"
        :active-value="col.activeValue || 1"
        :inactive-value="col.inactiveValue || 0"
        @change="col.change(scope.row)"
      />
      <div v-else-if="col.type == 'btns'">
        <template v-for="btn in col.btns">
          <el-button v-if="btn.if === undefined ? true : btn.if(scope.row)" :key="btn.title" v-permission="btn.permission" :type="btn.type" :size="btn.size || 'mini'" :class="btn.class" @click="btn.click(scope.row, scope.$index)">
            {{ btn.title }}
          </el-button>
        </template>
      </div>
      <el-image v-else-if="col.type === 'image'" :src="scope.row[col.field]" :preview-src-list="[scope.row[col.field]]" />
      <span v-else-if="col.type === 'html'" v-html="scope.row[col.field]"></span>
      <span v-else-if="col.click">
        <a style="color: blue" @click="col.click(scope.row)">{{ scope.row[col.field] }}</a>
      </span>
      <span v-else-if="col.field">{{ scope.row[col.field] }}</span>
    </template>
    <pd-table-column v-for="(col2, j) in col.cols" :key="j" :col="col2">
      <template v-for="(value, key) in $scopedSlots" #[key]="{ row, index }">
        <slot :row="row" :index="index" :name="key" />
      </template>
    </pd-table-column>
  </el-table-column>
</template>

<script>

export default {
  name: 'PdTableColumn',
  props: {
    col: {
      type: Object,
      default: () => {}
    }
  }
}
</script>

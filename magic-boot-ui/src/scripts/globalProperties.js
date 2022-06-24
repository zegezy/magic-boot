import * as PlusIcons from '@element-plus/icons-vue'
import request from './request'
import global from './global'
import common from './common'
import treeTable from './treeTable'

const install = (app) => {
  app.config.globalProperties.$request = request
  app.config.globalProperties.$post = common.$post
  app.config.globalProperties.$postJson = common.$postJson
  app.config.globalProperties.$get = common.$get
  app.config.globalProperties.$delete = common.$delete
  app.config.globalProperties.$global = global
  app.config.globalProperties.$common = common
  app.config.globalProperties.$treeTable = treeTable
  for(var key in PlusIcons) {
    app.component(`ElIcon${key}`, PlusIcons[key])
  }
}
export default install

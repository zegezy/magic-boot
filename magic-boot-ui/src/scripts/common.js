import request from '@/scripts/request'
import Vue from 'vue'
import { v4 as uuidv4 } from 'uuid'

const common = {}

let dictData = []
common.getDictData = async function() {
  await Vue.prototype.$request({
    url: 'dict/items/all',
    method: 'get'
  }).then((response) => {
    const { data } = response
    dictData = data
  })
}

common.getDictType = (type) => {
  return dictData.filter(it => it.type === type)
}

common.getDictLabel = (type, value) => {
  var values = []
  value.split(',').forEach(v => {
    const list = dictData.filter(it => it.type === type && it.value === v + '')
    values.push(list && list[0] && list[0].label || '')
  })
  return values.join(',')
}

common.handleDelete = (options) => {
  const url = options.url
  const id = options.id
  Vue.prototype.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    request({
      url: url,
      method: 'post',
      params: {
        id: id
      }
    }).then(() => {
      Vue.prototype.$notify({
        title: '成功',
        message: '删除成功',
        type: 'success',
        duration: 2000
      })
      options && options.done()
    })
  })
}

const formatJson = (list, filterVal) => {
  return list.map(v => filterVal.map(j => {
    return v[j]
  }))
}

common.exportExcel = (options) => {
  const where = options.where || {}
  where.current = 1
  where.size = 99999999
  const url = options.url
  const headers = options.headers
  const columns = options.columns
  request({
    url: url,
    method: 'post',
    params: where
  }).then(res => {
    import('@/vendor/Export2Excel').then(excel => {
      const data = formatJson(res.data, columns)
      excel.export_json_to_excel({
        header: headers,
        data,
        filename: 'table-list'
      })
    })
  })
}

common.handlerTreeData = (data, id, pid, sort, pidVal) => {
  var treeData = []
  var addChildren = (it) => {
    var children = data.filter(d => d[pid] === it[id])
    if (children && children.length > 0) {
      children.sort((a, b) => {
        return a[sort] - b[sort]
      })
      it.children = children
      children.forEach(chi => {
        addChildren(chi)
      })
    }
  }
  data.sort((a, b) => {
    return a[sort] - b[sort]
  })
  data.filter(it => it[pid] === pidVal).forEach(it => {
    addChildren(it)
    treeData.push(it)
  })
  return treeData
}

common.uuid = () => {
  return uuidv4().replace(/-/g, '')
}

common.objAssign = (obj1, obj2) => {
  for (var o1 in obj1) {
    for (var o2 in obj2) {
      if (o1 === o2) {
        obj1[o1] = obj2[o2]
      }
    }
  }
}

common.copyNew = (obj) => {
  return JSON.parse(JSON.stringify(obj))
}

common.getParam = (data) => {
  let url = ''
  for (var k in data) {
    const value = data[k] !== undefined ? data[k] : ''
    url += `&${k}=${encodeURIComponent(value)}`
  }
  return url ? url.substring(1) : ''
}

common.getUrl = (url, data) => {
  url += (url.indexOf('?') < 0 ? '?' : '') + common.getParam(data)
  return url
}

common.loadConfig = async() => {
  await request({
    url: 'config/list'
  }).then(res => {
    const { data } = res
    Vue.prototype.$filePrefix = data.filePrefix
  })
}

export default common

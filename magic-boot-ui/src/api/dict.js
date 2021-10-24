import request from '@/scripts/request'

export function saveData(params) {
  return request({
    url: 'dict/save',
    method: 'post',
    params
  })
}

export function getDictItems() {
  return new Promise((resolve, reject) => {
    request({
      url: 'dict/items/all',
      method: 'get'
    }).then(res => {
      resolve(res.data)
    })
  })
}

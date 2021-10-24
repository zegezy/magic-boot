import request from '@/scripts/request'

export function fetchList(params) {
  return request({
    url: 'cjBuildingBasis',
    method: 'post',
    data: params
  })
}

export function saveData(params) {
  return request({
    url: 'cjBuildingBasis/save',
    method: 'post',
    data: params
  })
}

export function removeData(id) {
  return request({
    url: 'cjBuildingBasis/delete',
    method: 'post',
    params: {
      id: id
    }
  })
}

export function getDetail(id) {
  return request({
    url: 'cjBuildingBasis/getDetail',
    method: 'get',
    params: {
      id: id
    }
  })
}


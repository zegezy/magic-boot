import request from '@/scripts/request'

export function login(data) {
  return request({
    url: 'security/login',
    method: 'post',
    data
  })
}

export function getInfo() {
  return request({
    url: 'user/info',
    method: 'get'
  })
}

export function logout() {
  return request({
    url: 'security/logout',
    method: 'get'
  })
}

export function fetchList(params) {
  return request({
    url: 'user/list',
    method: 'get',
    params
  })
}

export function saveData(params) {
  return request({
    url: 'user/save',
    method: 'post',
    params
  })
}

export function removeData(id) {
  return request({
    url: 'user/delete',
    method: 'post',
    params: {
      id: id
    }
  })
}

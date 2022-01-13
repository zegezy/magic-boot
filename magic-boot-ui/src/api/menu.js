import request from '@/scripts/request'

export function getMenuTree() {
  return request({
    url: 'menu/tree',
    method: 'get'
  })
}

export function getCurrentUserMenu() {
  return request({
    url: 'menu/current/menus',
    method: 'post'
  })
}

import request from '@/scripts/request'

export function getMenuTree() {
  return request({
    url: 'menu/tree',
    method: 'get'
  })
}

export function getMenusByRoleId(roleId) {
  return request({
    url: 'menu/by/role',
    method: 'get',
    params: {
      roleId
    }
  })
}

export function getCurrentUserMenu() {
  return request({
    url: 'menu/current/menus',
    method: 'post'
  })
}

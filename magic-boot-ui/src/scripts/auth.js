import global from './global'
import request from '@/scripts/request'
import { sha256 } from 'js-sha256'

const TokenKey = 'magic_boot_token'

export function getToken() {
  return localStorage.getItem(TokenKey);
}

export function setToken(token) {
  localStorage.setItem(TokenKey, token);
}

export function removeToken() {
  localStorage.removeItem(TokenKey);
  global.user = {
    authorities: [],
    info: {},
    permissionRoutes: []
  }
}

export async function getUserInfo() {
  await request({
    url: '/system/user/info',
    method: 'get'
  }).then(response => {
    const { data } = response
    if(data){
      var authorities_ = []
      for (var i = 0; i < data.authorities.length; i++) {
        authorities_.push(data.authorities[i])
      }
      global.user.authorities = authorities_
      global.user.info = data
    }
  })
}

export function login(data){
  return new Promise((resolve, reject) => {
    request({
      url: '/system/security/login',
      method: 'post',
      data: {
        username: data.username,
        password: sha256(data.password),
        code: data.code,
        uuid: data.uuid
      }
    }).then(res => {
      var token = res.data
      setToken(token)
      resolve(token)
    }).catch((e) => {
      reject(e)
    })
  })
}

export function logout(){
  request({
    url: '/system/security/logout',
    method: 'get'
  }).then(() => {
    removeToken()
    location.reload()
  })
}

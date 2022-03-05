import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { logout, login } from '@/scripts/auth'
import { getToken } from '@/scripts/auth'
import global from '@/scripts/global'

// create an axios instance
const service = axios.create({
  baseURL: import.meta.env.VITE_APP_BASE_API, // url = base url + request url
  // withCredentials: true, // send cookies when cross-domain requests
  timeout: 1000 * 60 // request timeout
})

// request interceptor
service.interceptors.request.use(
  config => {
    // do something before request is sent

    if (getToken()) {
      // let each request carry token
      // ['X-Token'] is a custom headers key
      // please modify it according to the actual situation
      config.headers['token'] = getToken()
    }
    return config
  },
  error => {
    // do something with request error
    console.log(error) // for debug
    return Promise.reject(error)
  }
)

var currentMessage
// response interceptor
service.interceptors.response.use(
  /**
   * If you want to get http information such as headers or status
   * Please return  response => response
  */

  /**
   * Determine the request status by custom code
   * Here is just an example
   * You can also judge the status by HTTP Status Code
   */
  response => {
    if (response.config.url.indexOf('user/info') !== -1 && response.data.code === 402) {
      logout()
    }
    return new Promise((reslove, reject) => {
      const res = response.data
      if (res.code !== 200) {
        var duration = 5
        if (res.code === 402) {
          duration = 1
          if(global.user.info.username){
            ElMessageBox.prompt(`当前账号：${global.user.info.username}凭证已过期，请输入密码重新登录`, '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '退出',
              inputType: 'password',
              closeOnClickModal: false,
              beforeClose: (action, instance, done) => {
                if (action === 'confirm') {
                  login({
                    username: global.user.info.username,
                    password: instance.inputValue
                  }).then((res) => {
                    if (res) {
                      done()
                      service(response.config).then(ret => reslove(ret))
                    }
                  })
                } else if (action === 'cancel') {
                  logout()
                } else {
                  done()
                }
              }
            })
          }
        }
        if (res.code !== 402) {
          if(currentMessage){
            currentMessage.close()
          }
          if(res.code == 403 && import.meta.env.NODE_ENV == 'preview'){
            res.message = '演示模式，不允许操作！'
          }
          currentMessage = ElMessage({
            message: res.message || 'Error',
            type: 'error',
            duration: duration * 1000,
            showClose: true
          })
          reject(res)
        }
      } else {
        reslove(res)
      }
    })
  },
  error => {
    // console.log('err' + error) // for debug
    if(currentMessage){
      currentMessage.close()
    }
    currentMessage = ElMessage({
      message: error.message,
      type: 'error',
      duration: 5 * 1000
    })
    return Promise.reject(error)
  }
)

export default service

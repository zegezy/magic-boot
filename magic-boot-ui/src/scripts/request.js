
import axios from 'axios'
import { Message } from 'element-ui'
import store from '@/store'
import { getToken } from '@/scripts/auth'

// create an axios instance
const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API, // url = base url + request url
  // withCredentials: true, // send cookies when cross-domain requests
  timeout: 1000 * 60 // request timeout
})

// request interceptor
service.interceptors.request.use(
  config => {
    // do something before request is sent

    if (store.getters.token) {
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

var isShowMsg = false
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
    const res = response.data
    // if the custom code is not 1, it is judged as an error.
    if (res.code !== 200) {
      var duration = 5
      if (res.code === 402) {
        duration = 1
      }
      if (isShowMsg === false) {
        Message({
          message: res.message || 'Error',
          type: 'error',
          duration: duration * 1000,
          showClose: true,
          onClose: function() {
            isShowMsg = false
            if (res.code === 402) {
              store.dispatch('user/logout').then(() => {
                location.reload()
              })
            }
          }
        })
        isShowMsg = true
      }
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      return res
    }
  },
  error => {
    // console.log('err' + error) // for debug
    if (isShowMsg === false) {
      Message({
        message: error.message,
        type: 'error',
        duration: 5 * 1000,
        onClose: function() {
          isShowMsg = false
        }
      })
      isShowMsg = true
    }
    return Promise.reject(error)
  }
)

export default service

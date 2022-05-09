<template>
  <div class="magic-login">
    <div class="magic-login-box">
<!--      <div class="magic-login-logo"></div>-->
      <div class="magic-login-text">{{ $global.title }}</div>
      <div class="magic-login-row">
        <input ref="username" class="magic-input" v-model="loginForm.username" placeholder="用户名" name="username" type="text" tabindex="1" auto-complete="on" />
        <mb-icon icon="user"/>
      </div>
      <div class="magic-login-row">
        <input class="magic-input" ref="password" v-model="loginForm.password" type="password" placeholder="密码" name="password" tabindex="2" auto-complete="on" @keyup.enter.native="handleLogin" />
        <mb-icon icon="password"/>
      </div>
      <div class="magic-login-row">
        <input class="magic-input code" ref="code" v-model="loginForm.code" placeholder="验证码" name="code" tabindex="3" @keyup.enter.native="handleLogin" />
        <mb-icon icon="verification-code"/>
        <img class="code-img" :src="codeImg" @click="refreshCode">
      </div>
      <div class="magic-login-row">
        <button :loading="loading" class="magic-button" type="primary" size="medium" @click.native.prevent="handleLogin">登录</button>
      </div>
    </div>
    <div class="magic-login-copyright">Copyright © 2020-{{new Date().getYear() + 1900}} <a href="https://ssssssss.org.cn" target="_blank">ssssssss.org.cn</a> All rights reserved.</div>
  </div>
</template>

<script setup>
  import { reactive, ref, getCurrentInstance } from 'vue'
  import { login } from '@/scripts/auth'
  const { proxy } = getCurrentInstance()
  const codeImg = ref()
  const loginForm = reactive({
    username: '',
    password: '',
    code: ''
  })
  const loading = ref(false)
  function refreshCode(){
    proxy.$get('/system/security/verification/code').then(res => {
      codeImg.value = 'data:image/png;base64,' + res.data.img
      loginForm.uuid = res.data.uuid
    })
  }
  refreshCode()
  function handleLogin() {
    if(!loginForm.username){
      proxy.$message({
        message: '请输入用户名',
        type: 'error',
        duration: 2000,
        showClose: true
      })
      return
    }else if(!loginForm.password){
      proxy.$message({
        message: '请输入密码',
        type: 'error',
        duration: 2000,
        showClose: true
      })
      return
    }else{
      loading.value = true
      login(loginForm).then((res) => {
        proxy.$router.push({ path: '/home' })
        loading.value = false
      }).catch(() => {
        refreshCode()
        loading.value = false
      })
    }
  }
</script>

<style scoped>
*{
  box-sizing: border-box;
}
.code{
  width: 283px;
  float: left;
  margin-right: 15px;
}
.code-img{
  border: 1px solid #D9D9D9;
  border-radius: 4px;
}
input{
  width: 100%;
}
label {
  width: 60px;
  text-align: right;
  display: inline-block;
}
.magic-login{
  position: fixed;
  background: #fff;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-image: url(../assets/images/login-bg.svg);
}
.magic-login .magic-login-box{
  border-radius: 5px;
  width: 450px;
  box-shadow: 0 7px 25px rgba(0,0,0,.08);
  position: absolute;
  box-sizing: border-box;
  /*padding-top:60px;*/
  padding-top:30px;
  top:33.333333%;
  margin-top: -125px;
  background-color: #fff;
}
.magic-login-logo{
  background-image: url(../assets/images/logo-magic-boot.png);
  width: 128px;
  height: 128px;
  background-size: 90px 90px;
  background-repeat: no-repeat;
  background-position: center center;
  position: absolute;
  top: -64px;
  left: 50%;
  margin-left: -64px;
  border-radius: 64px;
  box-shadow: 0 0 20px 5px rgba(0,0,0,.08);
  padding: 10px;
  background-color: #fff;
}
.magic-login-text{
  height: 70px;
  line-height: 70px;
  display: block;
  text-align: center;
  font-family: PoetsenOne;
  font-size: 28px;
  color: #808080;
}
.magic-login-text span{
  font-size: 16px;
}
.magic-login-copyright{
  text-align: center;
  color: #999;
  font-size: 18px;
  font-family: Avenir,Helvetica,Arial,sans-serif;
  position: absolute;
  bottom: 50px;
}
.magic-login-copyright a{
  text-decoration: none;
  color: #2196f3;
  outline: 0;
}
.magic-login-row{
  width: 400px;
  margin:25px auto;
  position: relative;
}
.magic-login-row svg{
  position: absolute;
  width: 20px;
  height: 20px;
  top: 15px;
  left: 15px;
}
.magic-login-box .magic-input{
  height: 50px;
  line-height: 50px;
  background-color: transparent;
  display: block;
  border: 1px solid #D9D9D9;
  border-radius: 4px;
  padding-left: 40px;
  color: rgba(0,0,0,.65);
  transition: all .3s;
  font-size: 16px;
  outline: 0;
}
.magic-login-box .magic-input:focus{
  border-color:#0784de;
}
.magic-login-box .magic-input:focus + svg{
  fill: #0784de;
}
.magic-login-box .magic-button{
  width: 100%;
  height: 50px;
  line-height: 50px;
  background-color: #2196f3;
  color: #fff;
  border-radius: 4px;
  font-size: 18px;
  border: 1px solid #ADADAD;
  border-color: #2196f3;
  transition: all .3s;
  cursor: pointer;
}
.magic-login-box .magic-button:hover,
.magic-login-box .magic-button:focus{
  background-color: #4db5ff !important;
  border-color: #4db5ff !important;
}
.magic-login-box .magic-button:active{
  background-color: #1272cc;
  border-color: #1272cc;
}
</style>

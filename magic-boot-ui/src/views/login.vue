<template>
  <div class="login-container">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on" label-position="left">
      <div class="login-box">
        <div class="title-container">
          Magic-Boot
        </div>
        <el-form-item prop="username">
          <span class="svg-container">
            <svg-icon icon-class="user" />
          </span>
          <el-input ref="username" v-model="loginForm.username" placeholder="用户名" name="username" type="text" tabindex="1" auto-complete="on" />
        </el-form-item>
        <el-form-item prop="password">
          <span class="svg-container">
            <svg-icon icon-class="password" />
          </span>
          <el-input :key="passwordType" ref="password" v-model="loginForm.password" :type="passwordType" placeholder="密码" name="password" tabindex="2" auto-complete="on" @keyup.enter.native="handleLogin" />
          <span class="show-pwd" @click="showPwd">
            <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
          </span>
        </el-form-item>
        <el-button :loading="loading" type="primary" size="medium" style="width:100%;margin-bottom:20px;font-size: 14px;" @click.native.prevent="handleLogin">登录</el-button>
      </div>
    </el-form>
    <div class="copyright">Copyright © 2020-{{new Date().getYear() + 1900}} <a href="https://ssssssss.org.cn" target="_blank">ssssssss.org.cn</a> All rights reserved.</div>
  </div>
</template>

<script>
import { login } from '@/scripts/auth'

export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [{ required: true, trigger: 'blur', message: '请输入用户名' }],
        password: [{ required: true, trigger: 'blur', message: '请输入密码' }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  methods: {
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          login(this.loginForm).then((res) => {
            console.log(this.$router)
            this.$router.push({ path: '/home' })
            this.loading = false
          }).catch(() => {
            this.loading = false
          })
        }
      })
    }
  }
}
</script>


<style lang="scss">
/* 修复input 背景不协调 和光标变色 */
/* Detail see https://github.com/PanJiaChen/vue-element-admin/pull/927 */

$bg: white;
$light_gray: rgba(0,0,0,.65);
$cursor: rgba(0,0,0,.65);

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}

/* reset element-ui css */
.login-container {
  .el-input {
    display: inline-block;
    height: 30px;
    width: 85%;

    input {
      background: transparent;
      border: 0px;
      -webkit-appearance: none;
      border-radius: 0px;
      padding: 3px;
      color: $light_gray;
      height: 30px;
      caret-color: $cursor;

      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px $bg inset !important;
        -webkit-text-fill-color: $cursor !important;
      }
    }
  }

  .el-form-item {
    border: 1px solid #D9D9D9;
    background: white;
    color: rgba(0,0,0,.65);
    border-radius: 5px;
  }
}
</style>

<style lang="scss" scoped>
$dark_gray:#889aa4;
$light_gray: rgba(0,0,0,.65);

.login-container {
  min-height: 100%;
  width: 100%;
  background-image: url(../assets/images/login-bg.svg);
  overflow: hidden;

  .login-form {
    position: relative;
    width: 450px;
    max-width: 100%;
    padding: 160px 35px 35px;
    margin: 0 auto;
    overflow: hidden;

    .login-box {
      background: white;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 7px 25px rgba(0,0,0,.08);
    }

  }

  .tips {
    font-size: 14px;
    color: #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .svg-container {
    padding-left: 10px;
    color: $dark_gray;
    width: 25px;
    display: inline-block;
  }

  .title-container {
    position: relative;
    text-align: center;
    margin-bottom: 20px;
    font-family: PoetsenOne;
    color: #808080;
    font-size: 26px;

    .title {
      font-size: 26px;
      color: $light_gray;
      margin: 0px auto 40px auto;
      text-align: center;
      font-weight: bold;
    }
  }

  .show-pwd {
    position: absolute;
    right: 10px;
    font-size: 16px;
    color: $dark_gray;
    cursor: pointer;
    user-select: none;
  }
}
.copyright{
  text-align: center;
  color: white;
  font-size: 18px;
  font-family: Avenir,Helvetica,Arial,sans-serif;
  position: absolute;
  bottom: 50px;
  width: 100%;
}
.copyright a{
  text-decoration: none;
  color: #2196f3;
  outline: 0;
}
</style>

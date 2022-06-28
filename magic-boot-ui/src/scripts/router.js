import { createRouter, createWebHashHistory } from 'vue-router'

import Layout from '@/layout/layout.vue'

const routes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect/index')
      }
    ]
  },

  {
    path: '/',
    component: Layout,
    redirect: '/home',
    children: [
      {
        path: '/home',
        component: () => import('@/views/home.vue'),
        meta: { title: '首页' }
      }
    ]
  },

  {
    path: '/user-center',
    redirect: '/system/user/user-center',
    component: Layout,
    hidden: true,
    children: [{
      path: '/system/user/user-center',
      component: () => import('@/views/system/user/user-center'),
      meta: { title: '个人中心' }
    }]
  },

  {
    path: '/login',
    component: () => import('@/views/login.vue'),
    hidden: true
  },
  // {
  //   path: '/404',
  //   name: '404',
  //   component: () => import('@/views/404.vue'),
  //   hidden: true
  // },
  // {
  //   path: '/:pathMatch(.*)*',
  //   redirect: '/404',
  //   hidden: true
  // }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router

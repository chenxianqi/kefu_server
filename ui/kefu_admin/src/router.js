import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
  // mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('./views/index.vue'),
      redirect: "/index",
      children: [
        {
          path: 'index',
          component: () => import('./views/home/index.vue'),
        },
        {
          path: 'workbench',
          component: () => import('./views/workbench/index.vue'),
        },
        {
          path: 'knowledge',
          component: () => import('./views/knowledge/index.vue'),
        },
        {
          path: 'robot',
          component: () => import('./views/robot/index.vue'),
        },
        {
          path: 'customer',
          component: () => import('./views/customer/index.vue'),
        },
        {
          path: 'users',
          component: () => import('./views/users/index.vue'),
        },
        {
          path: 'system',
          component: () => import('./views/system/index.vue'),
        },
        {
          path: 'chat_record',
          component: () => import('./views/record/index.vue')
        },
      ]
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('./views/auth/login.vue')
    },
    {path:'*',redirect: "/index"},
  ]
})

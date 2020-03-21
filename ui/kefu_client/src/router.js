import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)
const router = new Router({
    base: process.env.BASE_URL,
    routes: [
        {
            path: '/',
            name: 'kefu',
            component: () => import('./views/kefu.vue')
        },
        {
            path: '/workorder',
            name: 'workorder',
            component: () => import('./views/workorder.vue')
        },
        {
            path: '/workorder/create',
            name: 'workorder_create',
            component: () => import('./views/workorder_create.vue')
        },
        {
            path: '/workorder/detail',
            name: 'workorder_detail',
            component: () => import('./views/workorder_detail.vue')
        },
    ]
})

export default router

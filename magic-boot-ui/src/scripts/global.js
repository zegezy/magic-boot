import { reactive, ref } from 'vue'

export default {
  title: 'Magic Boot',
  user: {
    token: '',
    authorities: [],
    info: {},
    permissionRoutes: []
  },
  baseApi: import.meta.env.VITE_APP_BASE_API,
  visitedViews: reactive([]),
  tabValue: ref(''),
  dynamicComponentNames: []
}

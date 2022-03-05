import { reactive, ref } from 'vue'

export default {
  title: 'Magic Boot',
  user: {
    token: '',
    authorities: [],
    info: {},
    permissionRoutes: []
  },
  filePrefix: '',
  visitedViews: reactive([]),
  tabValue: ref('')
}
function gen(groupPath, data){
    var permissionPrefix = groupPath.replace('/', ':')
    var html = `
    <template>
      <mb-list ref="magicList" v-bind="listOptions" />
      <mb-dialog ref="formDialog" @confirm-click="magicForm.save($event)" width="50%">
        <template #content>
          <mb-form ref="magicForm" @reload="magicList.reload" v-bind="formOptions" />
        </template>
      </mb-dialog>
    </template>
    <script setup>
    import { ref, reactive, getCurrentInstance } from 'vue'
    const { proxy } = getCurrentInstance()
    const formDialog = ref()
    const magicList = ref()
    const magicForm = ref()
    const listOptions = reactive({
        tools: [{
            type: 'add',
            permission: '${permissionPrefix}:save',
            click: () => {
                formOptions.detail.formData = null
                formDialog.value.show()
            }
        }],
        table: {
            url: '${groupPath}/list',
            where: {`
    for(var i in data){
        var d = data[i]
        if(d.query){
            html += `
                ${d.columnName}: {
                    label: '${d.columnComment}'
                },`
        }
    }
    html = html.substring(0, html.length - 1)
    html += `
            },
            cols: [`
    for(var i in data){
        var d = data[i]
        if(d.list){
            if(d.dictType){
                html += `
                {
                    dictType: '${d.dictType}',`
            }else{
                html += `
                {
                `
            }
            html += `
                    field: '${d.columnName}',
                    label: '${d.columnComment}'
                },`
        }
    }
    html += `{
                    label: '操作',
                    type: 'btns',
                    width: 140,
                    fixed: 'right',
                    btns: [
                        {
                            permission: '${permissionPrefix}:save',
                            label: '修改',
                            type: 'text',
                            icon: 'ElEdit',
                            click: (row) => {
                                magicForm.value.getDetail(row.id)
                                formDialog.value.show()
                            }
                        }, {
                            permission: '${permissionPrefix}:delete',
                            label: '删除',
                            type: 'text',
                            icon: 'ElDelete',
                            click: (row) => {
                                proxy.$common.handleDelete({
                                    url: '${groupPath}/delete',
                                    id: row.id,
                                    done: () => magicList.value.reload()
                                })
                            }
                        }
                    ]
                }
            ]
        }
    })
    `
    html += `
    const formOptions = reactive({
        detail: {
            request: {
              url: '${groupPath}/get'
            }
        },
        form: {
            request: {
                url: "${groupPath}/save",
                method: "post"
            },
            rows: [{
                gutter: 24,
                cols: [`
    for(var i in data){
        var d = data[i]
        if(d.save){
            html += `{
                    span: 12,
                    name: '${d.columnName}',
                    label: '${d.columnComment}',
                    ${d.component}
                },`
        }
    }
    html = html.substring(0, html.length - 1)
    html += `]
            }]
        }
    })
    `

    console.log(html)
}
export default gen

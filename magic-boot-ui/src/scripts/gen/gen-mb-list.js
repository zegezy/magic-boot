function gen(groupPath, data){
    var permissionPrefix = groupPath.replace(/^\//,'').replace(/\/\//, '/').replace('/', ':')
    var html = `<template>
    <mb-list ref="magicList" v-bind="listOptions" />
    <mb-dialog ref="formDialog" :title="magicFormTitle" @confirm-click="magicForm.save($event)" width="50%">
        <template #content>
            <mb-form ref="magicForm" @reload="magicList.reload" v-bind="formOptions" />
        </template>
    </mb-dialog>
</template>
<script setup>
    import { ref, reactive, getCurrentInstance, nextTick } from 'vue'
    const { proxy } = getCurrentInstance()
    const formDialog = ref()
    const magicList = ref()
    const magicForm = ref()
    const magicFormTitle = ref()
    const listOptions = reactive({
        tools: [{
            type: 'add',
            permission: '${permissionPrefix}:save',
            click: () => {
                magicFormTitle.value = '添加'
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
                                magicFormTitle.value = '修改'
                                formDialog.value.show(() => magicForm.value.getDetail(row.id))
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
                url: "${groupPath}/save"
            },
            rows: [{
                gutter: 24,
                cols: [`
    for(var i in data){
        var d = data[i]
        if(d.save){
            var props = ''
            if(d.dictType){
                props = `props: {
                        type: '${d.dictType}'
                    }`
            }
            html += `{
                    span: 12,
                    name: '${d.columnName}',
                    label: '${d.columnComment}',
                    ${d.component},
                    ${props}
                },`
        }
    }
    html = html.substring(0, html.length - 1)
    html += `]
            }]
        }
    })
</script>`
    return html
}
export default gen

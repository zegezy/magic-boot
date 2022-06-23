function gen(groupPath, data){
    var permissionPrefix = groupPath.replace(/^\//,'').replace(/\/\//, '/').replaceAll('/', ':')
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
            var props = ''
            if(d.dictType){
                props = `,
                    props: {
                        type: '${d.dictType}'
                    }`
            }
            html += `
                ${d.columnName}: {
                    label: '${d.columnComment.trim()}',
                    ${d.component}${props}
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
            var type = ''
            if(d.component){
                if(d.component.indexOf('upload-image') != -1){
                    type = `,
                    type: 'image'`
                }
            }
            var dictType = ''
            if(d.dictType){
                dictType = `,
                    dictType: '${d.dictType}'`
            }
            html += `
                {
                    field: '${d.columnName}',
                    label: '${d.columnComment.trim()}'${type}${dictType}
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
                            type: 'primary',
                            link: true,
                            icon: 'ElIconEdit',
                            click: (row) => {
                                magicFormTitle.value = '修改'
                                formDialog.value.show(() => magicForm.value.getDetail(row.id))
                            }
                        }, {
                            permission: '${permissionPrefix}:delete',
                            label: '删除',
                            type: 'primary',
                            link: true,
                            icon: 'ElIconDelete',
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
                props = `,
                    props: {
                        type: '${d.dictType}'
                    }`
            }
            var rules = ''
            if(d.required){
                var messagePrefix = '请选择'
                if(d.component.indexOf('input') != -1){
                    messagePrefix = '请输入'
                }
                rules = `,
                    rules: [{ required: true, message: '${messagePrefix}${d.columnComment.trim()}', trigger: 'change' }]`
            }
            html += `{
                    span: 12,
                    name: '${d.columnName}',
                    label: '${d.columnComment.trim()}',
                    ${d.component}${props}${rules}
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

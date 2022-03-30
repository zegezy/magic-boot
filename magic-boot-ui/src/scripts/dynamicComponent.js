import { babelParse } from '@vue/compiler-sfc'
import { compileFile } from '@/compiler/sfc-compiler.js'
import { ElLoading, ElMessage } from 'element-plus'

export function appComponent(app, item){
    var compiled = {}
    compileFile('TestCode.vue', item.code, compiled)
    if(compiled.errors.length > 0){
        ElMessage({
            type: 'error',
            duration: 0,
            showClose: true,
            message: `
                组件“${item.name}”发生错误：
                ${compiled.errors[0]}
            `
        })
        throw compiled.errors[0]
    }else{
        var code = compiled.js
        var ast = babelParse(code, {
            sourceType: 'module'
        })
        var replaceCode = (node, subCode) => code.substring(0, node.start) + subCode + code.substring(node.end);
        for(var i = ast.program.body.length - 1; i>=0; i--){
            var node = ast.program.body[i]
            if(node.type === 'ImportDeclaration'){
                code = replaceCode(node, node.specifiers.map(it => `const ${it.local?.name || it.imported?.name || '*'} = ___magic__import__('${node.source.value}', '${it.imported?.name || '*'}');`).join('\r\n'));
            } else if (node.type === 'ExportDefaultDeclaration'){
                code = replaceCode(node, `return ${node.declaration.name}`)
            }
        }
        code = `(function(){
            ${code}
        })()`
        var componentStyle = document.createElement("style");
        componentStyle.innerHTML = compiled.css
        document.head.appendChild(componentStyle);
        app.component(item.name, eval(code))
    }
}
//
// const install = (app) => {
//     const loading = ElLoading.service({
//         lock: true,
//         background: 'rgba(255, 255, 255, 0)',
//     })
//     app.config.globalProperties.$post('/system/component/list').then((res) => {
//         res.data.forEach(it => {
//             appComponent(app, it)
//         })
//         loading.close()
//     })
// }
// export default install

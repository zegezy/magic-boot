import { babelParse } from '@vue/compiler-sfc'
import { compileFile } from '@/compiler/sfc-compiler.js'

function appComponent(app, item){
    var compiled = {}
    compileFile('TestCode.vue', item.code, compiled)
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

const install = (app) => {
    app.config.globalProperties.$post('/component/list', { size: 999999 }).then((res) => {
        res.data.list.forEach(it => {
            appComponent(app, it)
        })
    })
}
export default install

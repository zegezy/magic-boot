<script setup>
  import { babelParse } from '@vue/compiler-sfc'
  import { compileFile } from '@/compiler/sfc-compiler.js'
  import { testCode } from '@/compiler/testCode.js'
  import { getCurrentInstance } from '@vue/runtime-core'
  import {ref} from 'vue'
  var compiled = {}
  compileFile('TestCode.vue', testCode, compiled)
  var code = compiled.js
  // console.log(code)
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
  console.log(getCurrentInstance())
  getCurrentInstance().appContext.app.component('TestComp', eval(code))
  const xxClick = () => {
    console.log('click')
  }
</script>

<template>
  <component :is="'TestComp'"></component>
  <!-- <TestComp aaaaaa="666" @xxClick="xxClick"/> -->
</template>

<style scoped>
</style>

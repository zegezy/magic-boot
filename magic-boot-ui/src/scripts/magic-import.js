import * as vue from "vue";
import ElementPlus from "element-plus";

const libs = {
    vue,
    'element-plus': ElementPlus
}
window.___magic__import__ = function(lib, name){
    if(typeof(libs[lib]) == 'function'){
        return libs[lib]
    }
    return (libs[lib] || {})[name]
}

import * as vue from "vue";
import ElementPlus from "element-plus";

const libs = {
    vue,
    'element-plus': ElementPlus
}

window.___magic__import__ = function(lib, name){
    if(Object.prototype.toString.call(libs[lib]) != '[object Module]' && name == '*'){
        return libs[lib]
    }
    return (libs[lib] || {})[name]
}

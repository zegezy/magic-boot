import common from "@/scripts/common";

const treeTable = {}

treeTable.isChildren = (children, id) => {
  var result = false
  for(var i in children) {
    var chi = children[i]
    if(chi.id == id){
      result = true
    }
    if(chi.children && children.length > 0){
      if(treeTable.isChildren(chi.children, id)){
        result = true
      }
    }
  }
  return result
}

treeTable.queryChildren = (children, id) => {
  var result = []
  for(var i in children){
    var chi = children[i]
    if(chi.id == id){
      if(chi.children && chi.children.length > 0){
        result = chi.children
      }
    }else{
      var qc = treeTable.queryChildren(chi.children, id)
      if(qc.length > 0){
        result = qc
      }
    }
  }
  return result
}

treeTable.genTree = (children) => {
  var treeData = []
  for(var i in children){
    var chi = {}
    chi.label = children[i].name
    chi.id = children[i].id
    if(children[i].children && children[i].children.length > 0){
      chi.children = treeTable.genTree(children[i].children)
    }
    treeData.push(chi)
  }
  return treeData
}

treeTable.recursionSearch = (fields, data, text) => {
  var searchData = []
  for(var i in data){
    var treeNode = data[i]
    var children = treeNode.children
    if(children && children.length > 0){
      var childrenSearch = treeTable.recursionSearch(fields, children, text)
      treeNode.children = childrenSearch && childrenSearch.length > 0 ? childrenSearch : treeNode.children
      treeTable.treeNodeReplace(fields, searchData, treeNode, text, childrenSearch)
    }else{
      treeTable.treeNodeReplace(fields, searchData, treeNode, text)
    }
  }
  return searchData
}

treeTable.treeNodeReplace = (fields, searchData, treeNode, text, childrenSearch) => {
  var exist = false
  fields.forEach((f) => {
    if(treeNode[f] && treeNode[f].indexOf(text) != -1){
      treeNode[f] = treeNode[f].replace(text, `<font color="#FAA353">${text}</font>`)
      exist = true
    }
  })
  if(exist || (childrenSearch && childrenSearch.length > 0)){
    searchData.push(treeNode)
  }
}

export default treeTable
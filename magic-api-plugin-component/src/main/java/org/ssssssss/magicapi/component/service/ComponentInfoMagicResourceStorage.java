package org.ssssssss.magicapi.component.service;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.ssssssss.magicapi.component.model.ComponentInfo;
import org.ssssssss.magicapi.core.exception.InvalidArgumentException;
import org.ssssssss.magicapi.core.model.Group;
import org.ssssssss.magicapi.core.model.JsonCode;
import org.ssssssss.magicapi.core.model.MagicEntity;
import org.ssssssss.magicapi.core.model.TreeNode;
import org.ssssssss.magicapi.core.service.AbstractPathMagicResourceStorage;
import org.ssssssss.magicapi.core.service.MagicResourceService;

import java.util.List;
import java.util.UUID;

public class ComponentInfoMagicResourceStorage extends AbstractPathMagicResourceStorage<ComponentInfo> {

	@Override
	public String folder() {
		return "component";
	}

	@Override
	public Class<ComponentInfo> magicClass() {
		return ComponentInfo.class;
	}

	private boolean strIsEnglish(String word) {
		boolean sign = true;
		for (int i = 0; i < word.length(); i++) {
			if (!(word.charAt(i) >= 'A' && word.charAt(i) <= 'Z')
					&& !(word.charAt(i) >= 'a' && word.charAt(i) <= 'z')) {
				return false;
			}
		}
		return true;
	}

	public void isNameRepeat(List<TreeNode<Group>> groupChildren, String name, String id){
		groupChildren.stream().forEach(it -> {
			Group node = it.getNode();
			List<TreeNode<Group>> chi = it.getChildren();
			magicResourceService.listFiles(node.getId()).forEach(file -> {
				if(null != id){
					if(!file.getId().equals(id) && file.getName().equals(name)){
						throw new InvalidArgumentException(new JsonCode(9004, "组件名称已存在"));
					}
				}else{
					if(file.getName().equals(name)){
						throw new InvalidArgumentException(new JsonCode(9004, "组件名称已存在"));
					}
				}
			});
			if(chi.size() > 0){
				isNameRepeat(chi, name, id);
			}
		});
	}

	@Override
	public void validate(ComponentInfo entity) {
		if(null == entity.getPath() || entity.getPath().equals("")){
			entity.setPath(UUID.randomUUID().toString().replace("-", ""));
		}
		isNameRepeat(magicResourceService.tree("component").getChildren(), entity.getName(), entity.getId());
		notBlank(entity.getName(), new JsonCode(9001, "组件名称不能为空"));
		if(!strIsEnglish(entity.getName())){
			throw new InvalidArgumentException(new JsonCode(9002, "组件名称必须是英文"));
		}
		notBlank(entity.getDescription(), new JsonCode(9003, "组件描述不能为空"));
	}

	@Override
	public String buildMappingKey(ComponentInfo info) {
		return buildMappingKey(info, magicResourceService.getGroupPath(info.getGroupId()));
	}

	@Override
	public boolean requirePath() {
		return false;
	}

}

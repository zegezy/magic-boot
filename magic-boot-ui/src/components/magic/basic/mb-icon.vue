<template>
	<svg aria-hidden="true" class="mb-icon">
		<use :xlink:href="symbolId" :class="className"/>
	</svg>
</template>
<script setup>
import { computed } from 'vue'
const props = defineProps({
	prefix: {
		type: String,
		default: 'mb-icon'
	},
	icon: String
});
const symbolId = computed(() => props.icon&&props.icon.startsWith('#') ? props.icon : `#${props.prefix}-${props.icon}`)
const className = computed(() => props.icon&&props.icon.startsWith('#') ? props.icon.substring(1) : `${props.prefix}-${props.icon}`)
</script>
<style scoped>
svg {
	width: 1.3em;
	height: 1.3em;
	vertical-align: -0.25em;
	overflow: hidden;
	fill: var(--mb-main-icon-color)
}
</style>

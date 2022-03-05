const svgs = import.meta.glob('../icons/*.svg')
const svgNames = []
for (const [key, value] of Object.entries(svgs)) {
  svgNames.push(key.substring(key.lastIndexOf('/') + 1, key.lastIndexOf('.')))
}
export default svgNames
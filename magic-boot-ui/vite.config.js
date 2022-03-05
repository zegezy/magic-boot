import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'
import viteSvgIcons from 'vite-plugin-svg-icons'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    viteSvgIcons({
			iconDirs: [path.resolve(process.cwd(), 'src/icons')],
			symbolId: 'mb-icon-[name]'
		})
  ],
  resolve: {
    extensions: ['.vue', '.json', '.js'],
    alias: {
      '@': path.resolve(__dirname,'src')
    }
  }
})

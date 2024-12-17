import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': '/src'
    }
  },
  build: {
    outDir: 'public/assets',
    rollupOptions: {
      input: '/app/javascript/application.js'
    }
  }
})
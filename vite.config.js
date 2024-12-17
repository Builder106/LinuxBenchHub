import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'app/javascript'),
      '@rails/ujs': path.resolve(__dirname, 'node_modules/@rails/ujs'),
      'turbolinks': path.resolve(__dirname, 'node_modules/turbolinks'),
      '@rails/activestorage': path.resolve(__dirname, 'node_modules/@rails/activestorage'),
      'channels': path.resolve(__dirname, 'app/javascript/channels')
    }
  },
  build: {
    outDir: 'public/assets',
    rollupOptions: {
      input: path.resolve(__dirname, 'app/javascript/application.js')
    }
  }
});
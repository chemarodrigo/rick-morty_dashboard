export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  modules: ['@pinia/nuxt', '@nuxtjs/tailwindcss'],
  typescript: { strict: true },
  tailwindcss: { cssPath: '~/assets/css/main.css' },
  app: {
    head: {
      title: 'Rick & Morty Dashboard',
      meta: [
        { name: 'description', content: 'Character management dashboard using Rick and Morty API' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      ],
    },
    pageTransition: { name: 'page', mode: 'out-in' },
  },
})

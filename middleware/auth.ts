export default defineNuxtRouteMiddleware((to) => {
  if (import.meta.client) {
    const token = localStorage.getItem('auth_token')
    if (!token && to.path.startsWith('/dashboard')) {
      return navigateTo('/login')
    }
    if (token && to.path === '/login') {
      return navigateTo('/dashboard')
    }
  }
})

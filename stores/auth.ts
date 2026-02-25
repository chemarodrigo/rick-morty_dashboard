import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(null)
  const userEmail = ref<string | null>(null)

  const isAuthenticated = computed(() => !!token.value)

  function login(email: string, password: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email) || password.length <= 6) return false

    const fakeToken = `token_${Date.now()}`
    token.value = fakeToken
    userEmail.value = email

    if (import.meta.client) {
      localStorage.setItem('auth_token', fakeToken)
      localStorage.setItem('user_email', email)
    }
    return true
  }

  function logout() {
    token.value = null
    userEmail.value = null
    if (import.meta.client) {
      localStorage.removeItem('auth_token')
      localStorage.removeItem('user_email')
    }
  }

  function hydrateFromStorage() {
    if (import.meta.client) {
      token.value = localStorage.getItem('auth_token')
      userEmail.value = localStorage.getItem('user_email')
    }
  }

  return { token, userEmail, isAuthenticated, login, logout, hydrateFromStorage }
})

<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'

definePageMeta({ middleware: 'auth' })

const authStore = useAuthStore()
const router = useRouter()

const email = ref('')
const password = ref('')
const isLoading = ref(false)
const emailError = ref('')
const passwordError = ref('')
const generalError = ref('')

function validate(): boolean {
  emailError.value = ''
  passwordError.value = ''
  let isValid = true
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!email.value) { emailError.value = 'Email is required.'; isValid = false }
  else if (!emailRegex.test(email.value)) { emailError.value = 'Please enter a valid email address.'; isValid = false }
  if (!password.value) { passwordError.value = 'Password is required.'; isValid = false }
  else if (password.value.length <= 6) { passwordError.value = 'Password must be longer than 6 characters.'; isValid = false }
  return isValid
}

async function handleLogin() {
  generalError.value = ''
  if (!validate()) return
  isLoading.value = true
  await new Promise((resolve) => setTimeout(resolve, 600))
  const success = authStore.login(email.value, password.value)
  if (success) { await router.push('/dashboard') }
  else { generalError.value = 'Invalid credentials. Please try again.' }
  isLoading.value = false
}
</script>
<template>
  <div class="flex min-h-screen items-center justify-center bg-gray-900 px-4">
    <div class="pointer-events-none fixed inset-0 overflow-hidden">
      <div class="absolute -left-40 -top-40 h-80 w-80 rounded-full bg-portal-green/10 blur-3xl" />
      <div class="absolute -bottom-40 -right-40 h-80 w-80 rounded-full bg-portal-blue/10 blur-3xl" />
    </div>
    <div class="relative w-full max-w-sm rounded-2xl border border-gray-700 bg-gray-800 p-8 shadow-2xl">
      <div class="mb-8 text-center">
        <div class="mb-3 text-5xl">🛸</div>
        <h1 class="text-2xl font-bold text-white">Welcome back</h1>
        <p class="mt-1 text-sm text-gray-400">Sign in to access the Rick &amp; Morty Dashboard</p>
      </div>
      <form class="flex flex-col gap-5" @submit.prevent="handleLogin">
        <UiAppInput id="email" v-model="email" label="Email" type="email" placeholder="rick@citadel.space" :error="emailError" />
        <UiAppInput id="password" v-model="password" label="Password" type="password" placeholder="••••••••" :error="passwordError" />
        <Transition name="fade">
          <p v-if="generalError" class="text-center text-sm text-red-400">{{ generalError }}</p>
        </Transition>
        <UiAppButton type="submit" :loading="isLoading" class="mt-2 w-full">
          {{ isLoading ? 'Signing in...' : 'Sign in' }}
        </UiAppButton>
      </form>
      <p class="mt-6 text-center text-xs text-gray-600">Use any valid email and a password longer than 6 characters.</p>
    </div>
  </div>
</template>

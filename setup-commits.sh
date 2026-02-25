#!/bin/bash

# ─────────────────────────────────────────────────────────────────
# Rick & Morty Dashboard — Git history setup script
# Run this in a fresh GitHub Codespace terminal
# ─────────────────────────────────────────────────────────────────

set -e  # Exit immediately if any command fails

echo "🛸 Starting Rick & Morty Dashboard commit history setup..."
echo ""

# ─── Git config ──────────────────────────────────────────────────
git config user.email "you@example.com"
git config user.name "Your Name"

# ════════════════════════════════════════════════════════════════
# COMMIT 1 — Project scaffolding
# ════════════════════════════════════════════════════════════════

cat > package.json << 'EOF'
{
  "name": "rick-morty-dashboard",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "postinstall": "nuxt prepare",
    "test": "vitest",
    "test:coverage": "vitest --coverage"
  },
  "devDependencies": {
    "@nuxtjs/tailwindcss": "^6.12.1",
    "@pinia/nuxt": "^0.5.5",
    "@vitejs/plugin-vue": "^5.1.4",
    "@vitest/coverage-v8": "^3.2.0",
    "@vue/test-utils": "^2.4.6",
    "happy-dom": "^15.7.4",
    "nuxt": "^3.16.0",
    "pinia": "^2.2.4",
    "typescript": "^5.6.3",
    "vitest": "^3.2.0",
    "vue": "^3.5.12",
    "vue-router": "^4.4.5"
  }
}
EOF

cat > nuxt.config.ts << 'EOF'
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
EOF

cat > tsconfig.json << 'EOF'
{
  "extends": "./.nuxt/tsconfig.json",
  "compilerOptions": {
    "strict": true,
    "skipLibCheck": true
  }
}
EOF

cat > tailwind.config.js << 'EOF'
export default {
  content: [
    './components/**/*.{js,vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './app.vue',
  ],
  theme: {
    extend: {
      colors: {
        portal: {
          green: '#97CE4C',
          blue: '#44B3D0',
          dark: '#1F2937',
        },
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
EOF

cat > vitest.config.ts << 'EOF'
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = fileURLToPath(new URL('.', import.meta.url))

export default defineConfig({
  plugins: [vue()],
  resolve: { alias: { '~/': resolve(__dirname, './') } },
  test: {
    environment: 'happy-dom',
    globals: true,
    alias: { '~/': resolve(__dirname, './') },
  },
})
EOF

echo "legacy-peer-deps=true" > .npmrc

cat > app.vue << 'EOF'
<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'
import { useFavoritesStore } from '~/stores/favorites'

const authStore = useAuthStore()
const favStore = useFavoritesStore()

onMounted(() => {
  authStore.hydrateFromStorage()
  favStore.hydrateFromStorage()
})
</script>

<template>
  <div class="min-h-screen bg-gray-900 text-white">
    <NuxtPage />
  </div>
</template>
EOF

git add .
git commit -m "chore: initial project setup — Nuxt 3, Pinia, Tailwind, TypeScript, Vitest"
echo "✅ Commit 1 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 2 — TypeScript types
# ════════════════════════════════════════════════════════════════

mkdir -p types

cat > types/character.ts << 'EOF'
export interface ApiInfo {
  count: number
  pages: number
  next: string | null
  prev: string | null
}

export interface Character {
  id: number
  name: string
  status: 'Alive' | 'Dead' | 'unknown'
  species: string
  type: string
  gender: 'Female' | 'Male' | 'Genderless' | 'unknown'
  origin: Location
  location: Location
  image: string
  episode: string[]
  url: string
  created: string
}

export interface Location {
  name: string
  url: string
}

export interface CharactersResponse {
  info: ApiInfo
  results: Character[]
}

export interface FetchState<T> {
  data: T | null
  pending: boolean
  error: string | null
}
EOF

git add .
git commit -m "feat: TypeScript interfaces for Rick and Morty API responses"
echo "✅ Commit 2 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 3 — Auth store
# ════════════════════════════════════════════════════════════════

mkdir -p stores

cat > stores/auth.ts << 'EOF'
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
EOF

git add .
git commit -m "feat: auth store with simulated login, logout and localStorage persistence"
echo "✅ Commit 3 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 4 — Favorites store
# ════════════════════════════════════════════════════════════════

cat > stores/favorites.ts << 'EOF'
import { defineStore } from 'pinia'
import type { Character } from '~/types/character'

const STORAGE_KEY = 'rm_favorites'

export const useFavoritesStore = defineStore('favorites', () => {
  const favorites = ref<Character[]>([])

  const favoritesCount = computed(() => favorites.value.length)

  function isFavorite(id: number): boolean {
    return favorites.value.some((c) => c.id === id)
  }

  function toggleFavorite(character: Character) {
    const index = favorites.value.findIndex((c) => c.id === character.id)
    if (index === -1) {
      favorites.value.push(character)
    } else {
      favorites.value.splice(index, 1)
    }
    persist()
  }

  function removeFavorite(id: number) {
    favorites.value = favorites.value.filter((c) => c.id !== id)
    persist()
  }

  function clearFavorites() {
    favorites.value = []
    persist()
  }

  function persist() {
    if (import.meta.client) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(favorites.value))
    }
  }

  function hydrateFromStorage() {
    if (import.meta.client) {
      const stored = localStorage.getItem(STORAGE_KEY)
      if (stored) {
        try { favorites.value = JSON.parse(stored) as Character[] }
        catch { favorites.value = [] }
      }
    }
  }

  return {
    favorites, favoritesCount, isFavorite,
    toggleFavorite, removeFavorite, clearFavorites, hydrateFromStorage,
  }
})
EOF

git add .
git commit -m "feat: favorites store with toggle, clear and localStorage persistence"
echo "✅ Commit 4 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 5 — Auth middleware
# ════════════════════════════════════════════════════════════════

mkdir -p middleware

cat > middleware/auth.ts << 'EOF'
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
EOF

git add .
git commit -m "feat: auth middleware — protects /dashboard routes and redirects unauthenticated users"
echo "✅ Commit 5 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 6 — CSS and global styles
# ════════════════════════════════════════════════════════════════

mkdir -p assets/css

cat > assets/css/main.css << 'EOF'
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

.page-enter-active, .page-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}
.page-enter-from { opacity: 0; transform: translateY(8px); }
.page-leave-to { opacity: 0; transform: translateY(-8px); }

.card-list-enter-active, .card-list-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.card-list-enter-from, .card-list-leave-to { opacity: 0; transform: scale(0.95); }

.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { @apply bg-gray-900; }
::-webkit-scrollbar-thumb { @apply bg-portal-green rounded-full; }
EOF

git add .
git commit -m "feat: global CSS — Tailwind directives, page/card/fade transitions and scrollbar styling"
echo "✅ Commit 6 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 7 — Reusable UI components
# ════════════════════════════════════════════════════════════════

mkdir -p components/ui

cat > components/ui/AppButton.vue << 'EOF'
<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost'
  disabled?: boolean
  loading?: boolean
  type?: 'button' | 'submit' | 'reset'
}
const props = withDefaults(defineProps<Props>(), {
  variant: 'primary', disabled: false, loading: false, type: 'button',
})
const variantClasses: Record<string, string> = {
  primary: 'bg-portal-green text-gray-900 hover:brightness-110 focus-visible:ring-portal-green',
  secondary: 'bg-portal-blue text-white hover:brightness-110 focus-visible:ring-portal-blue',
  danger: 'bg-red-600 text-white hover:bg-red-700 focus-visible:ring-red-500',
  ghost: 'bg-transparent text-gray-300 border border-gray-600 hover:border-portal-green hover:text-portal-green focus-visible:ring-gray-500',
}
</script>
<template>
  <button
    :type="props.type"
    :disabled="props.disabled || props.loading"
    :class="[variantClasses[props.variant], 'inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold transition-all duration-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-offset-gray-900 disabled:opacity-50 disabled:cursor-not-allowed']"
  >
    <svg v-if="props.loading" class="h-4 w-4 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
    </svg>
    <slot />
  </button>
</template>
EOF

cat > components/ui/AppInput.vue << 'EOF'
<script setup lang="ts">
interface Props {
  label?: string
  type?: 'text' | 'email' | 'password'
  placeholder?: string
  error?: string
  id?: string
}
withDefaults(defineProps<Props>(), { label: '', type: 'text', placeholder: '', error: '', id: '' })
const model = defineModel<string>({ default: '' })
</script>
<template>
  <div class="flex flex-col gap-1">
    <label v-if="label" :for="id" class="text-sm font-medium text-gray-300">{{ label }}</label>
    <input
      :id="id" v-model="model" :type="type" :placeholder="placeholder"
      :class="['w-full rounded-lg border bg-gray-800 px-4 py-2.5 text-sm text-white placeholder-gray-500 transition-colors duration-200 outline-none', error ? 'border-red-500 focus:border-red-400' : 'border-gray-600 focus:border-portal-green']"
    />
    <Transition name="fade">
      <p v-if="error" class="text-xs text-red-400">{{ error }}</p>
    </Transition>
  </div>
</template>
EOF

cat > components/ui/AppSpinner.vue << 'EOF'
<script setup lang="ts">
interface Props { message?: string }
withDefaults(defineProps<Props>(), { message: 'Loading...' })
</script>
<template>
  <div class="flex flex-col items-center justify-center gap-4 py-20">
    <svg class="h-12 w-12 animate-spin text-portal-green" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
    </svg>
    <p class="text-sm text-gray-400">{{ message }}</p>
  </div>
</template>
EOF

git add .
git commit -m "feat: reusable UI components — AppButton (4 variants), AppInput and AppSpinner"
echo "✅ Commit 7 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 8 — useCharacters composable
# ════════════════════════════════════════════════════════════════

mkdir -p composables

cat > composables/useCharacters.ts << 'EOF'
import type { Character, ApiInfo } from '~/types/character'

const BASE_URL = 'https://rickandmortyapi.com/api'

export function useCharacters() {
  const characters = ref<Character[]>([])
  const info = ref<ApiInfo | null>(null)
  const pending = ref(false)
  const error = ref<string | null>(null)
  const currentPage = ref(1)
  const searchQuery = ref('')
  const lastPage = ref(1)
  const lastQuery = ref('')

  const hasNextPage = computed(() => !!info.value?.next)
  const hasPrevPage = computed(() => !!info.value?.prev)
  const totalPages = computed(() => info.value?.pages ?? 1)

  async function fetchCharacters(page = 1, name = '') {
    lastPage.value = page
    lastQuery.value = name
    pending.value = true
    error.value = null
    characters.value = []

    try {
      const params = new URLSearchParams({ page: String(page) })
      if (name.trim()) params.set('name', name.trim())
      const url = `${BASE_URL}/character?${params.toString()}`
      const response = await $fetch<{ info: ApiInfo; results: Character[] }>(url)
      characters.value = response.results
      info.value = response.info
      currentPage.value = page
      searchQuery.value = name
    } catch (err: unknown) {
      if (isNotFoundError(err)) {
        characters.value = []
        info.value = null
        error.value = 'No characters found matching your search.'
      } else {
        error.value = 'Something went wrong. Please try again.'
        console.error('[useCharacters] fetch error:', err)
      }
    } finally {
      pending.value = false
    }
  }

  async function retry() { await fetchCharacters(lastPage.value, lastQuery.value) }
  async function nextPage() { if (hasNextPage.value) await fetchCharacters(currentPage.value + 1, searchQuery.value) }
  async function prevPage() { if (hasPrevPage.value) await fetchCharacters(currentPage.value - 1, searchQuery.value) }
  async function search(name: string) { searchQuery.value = name; await fetchCharacters(1, name) }

  function isNotFoundError(err: unknown): boolean {
    return typeof err === 'object' && err !== null && 'statusCode' in err && (err as { statusCode: number }).statusCode === 404
  }

  return { characters, info, pending, error, currentPage, searchQuery, totalPages, hasNextPage, hasPrevPage, fetchCharacters, retry, nextPage, prevPage, search }
}
EOF

git add .
git commit -m "feat: useCharacters composable — API fetching, search, pagination and retry logic"
echo "✅ Commit 8 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 9 — Business components
# ════════════════════════════════════════════════════════════════

cat > components/CharacterCard.vue << 'EOF'
<script setup lang="ts">
import type { Character } from '~/types/character'

interface Props { character: Character; isFavorite: boolean }
const props = defineProps<Props>()
const emit = defineEmits<{ (e: 'toggle-favorite', character: Character): void }>()

const statusColour: Record<string, string> = { Alive: 'bg-portal-green', Dead: 'bg-red-500', unknown: 'bg-gray-500' }
</script>
<template>
  <article class="group relative flex flex-col overflow-hidden rounded-xl border border-gray-700 bg-gray-800 shadow-md transition-all duration-300 hover:-translate-y-1 hover:border-portal-green hover:shadow-portal-green/20 hover:shadow-lg">
    <div class="relative overflow-hidden">
      <img :src="props.character.image" :alt="props.character.name" class="h-48 w-full object-cover transition-transform duration-300 group-hover:scale-105" loading="lazy" />
      <button :aria-label="isFavorite ? 'Remove from favorites' : 'Add to favorites'" class="absolute right-2 top-2 rounded-full bg-gray-900/80 p-1.5 backdrop-blur-sm transition-transform duration-200 hover:scale-110 focus:outline-none" @click.stop="emit('toggle-favorite', props.character)">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" :fill="isFavorite ? '#97CE4C' : 'none'" :stroke="isFavorite ? '#97CE4C' : '#9CA3AF'" stroke-width="2" class="h-5 w-5 transition-colors duration-200">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
        </svg>
      </button>
    </div>
    <div class="flex flex-1 flex-col gap-2 p-4">
      <h3 class="truncate text-base font-bold text-white" :title="props.character.name">{{ props.character.name }}</h3>
      <div class="flex items-center gap-2">
        <span :class="statusColour[props.character.status] ?? 'bg-gray-500'" class="h-2.5 w-2.5 rounded-full" />
        <span class="text-sm text-gray-300">{{ props.character.status }} — {{ props.character.species }}</span>
      </div>
      <div class="mt-auto pt-2 text-xs text-gray-500">
        <p class="font-medium uppercase tracking-wide text-gray-400">Last seen</p>
        <p class="truncate text-gray-300">{{ props.character.location.name }}</p>
      </div>
    </div>
  </article>
</template>
EOF

cat > components/SearchBar.vue << 'EOF'
<script setup lang="ts">
const emit = defineEmits<{ (e: 'search', query: string): void }>()
const query = ref('')
let debounceTimer: ReturnType<typeof setTimeout> | null = null

function onInput() {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => emit('search', query.value), 400)
}
function clearSearch() { query.value = ''; emit('search', '') }
</script>
<template>
  <div class="relative w-full max-w-md">
    <svg class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
      <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
    </svg>
    <input v-model="query" type="text" placeholder="Search characters..." class="w-full rounded-lg border border-gray-600 bg-gray-800 py-2.5 pl-10 pr-10 text-sm text-white placeholder-gray-500 outline-none transition-colors duration-200 focus:border-portal-green" @input="onInput" />
    <Transition name="fade">
      <button v-if="query" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white" aria-label="Clear search" @click="clearSearch">
        <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </Transition>
  </div>
</template>
EOF

cat > components/Pagination.vue << 'EOF'
<script setup lang="ts">
interface Props { currentPage: number; totalPages: number; hasPrev: boolean; hasNext: boolean }
defineProps<Props>()
const emit = defineEmits<{ (e: 'prev'): void; (e: 'next'): void }>()
</script>
<template>
  <div class="flex items-center justify-center gap-4">
    <button :disabled="!hasPrev" class="flex items-center gap-2 rounded-lg border border-gray-600 bg-gray-800 px-4 py-2 text-sm font-medium text-gray-300 transition-all duration-200 hover:border-portal-green hover:text-portal-green disabled:cursor-not-allowed disabled:opacity-40" @click="emit('prev')">
      <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" /></svg>
      Previous
    </button>
    <span class="text-sm text-gray-400">Page <span class="font-bold text-white">{{ currentPage }}</span> of <span class="font-bold text-white">{{ totalPages }}</span></span>
    <button :disabled="!hasNext" class="flex items-center gap-2 rounded-lg border border-gray-600 bg-gray-800 px-4 py-2 text-sm font-medium text-gray-300 transition-all duration-200 hover:border-portal-green hover:text-portal-green disabled:cursor-not-allowed disabled:opacity-40" @click="emit('next')">
      Next
      <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" /></svg>
    </button>
  </div>
</template>
EOF

git add .
git commit -m "feat: CharacterCard, SearchBar (debounced) and Pagination components"
echo "✅ Commit 9 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 10 — Navbar
# ════════════════════════════════════════════════════════════════

cat > components/AppNavbar.vue << 'EOF'
<script setup lang="ts">
import { useAuthStore } from '~/stores/auth'
import { useFavoritesStore } from '~/stores/favorites'

const authStore = useAuthStore()
const favStore = useFavoritesStore()
const router = useRouter()
const route = useRoute()

async function handleLogout() {
  authStore.logout()
  await router.push('/login')
}

function handleLogoClick() {
  if (route.path === '/dashboard') { router.go(0) } else { router.push('/dashboard') }
}
</script>
<template>
  <header class="sticky top-0 z-50 border-b border-gray-700 bg-gray-900/95 backdrop-blur-sm">
    <div class="mx-auto flex max-w-7xl items-center justify-between px-4 py-3 sm:px-6">
      <div class="flex cursor-pointer items-center gap-2 group" @click="handleLogoClick">
        <span class="text-2xl">🛸</span>
        <span class="text-lg font-bold text-white transition-colors duration-200 group-hover:text-portal-green">Rick &amp; Morty</span>
      </div>
      <nav class="flex items-center gap-1 sm:gap-4">
        <NuxtLink to="/dashboard" class="rounded-lg px-3 py-2 text-sm font-medium text-gray-300 transition-colors duration-200 hover:text-portal-green" active-class="text-portal-green">Characters</NuxtLink>
        <NuxtLink to="/dashboard/favorites" class="relative rounded-lg px-3 py-2 text-sm font-medium text-gray-300 transition-colors duration-200 hover:text-portal-green" active-class="text-portal-green">
          Favorites
          <Transition name="fade">
            <span v-if="favStore.favoritesCount > 0" class="absolute -right-0.5 -top-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-portal-green text-[10px] font-bold text-gray-900">
              {{ favStore.favoritesCount > 9 ? '9+' : favStore.favoritesCount }}
            </span>
          </Transition>
        </NuxtLink>
      </nav>
      <div class="flex items-center gap-3">
        <span class="hidden text-xs text-gray-500 sm:block">{{ authStore.userEmail }}</span>
        <button class="rounded-lg border border-gray-600 px-3 py-1.5 text-sm text-gray-300 transition-all duration-200 hover:border-red-500 hover:text-red-400" @click="handleLogout">Logout</button>
      </div>
    </div>
  </header>
</template>
EOF

git add .
git commit -m "feat: AppNavbar with logo reset, favorites badge and logout"
echo "✅ Commit 10 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 11 — Login page
# ════════════════════════════════════════════════════════════════

mkdir -p pages

cat > pages/index.vue << 'EOF'
<script setup lang="ts">
definePageMeta({ middleware: 'auth' })
navigateTo('/dashboard')
</script>
<template><div /></template>
EOF

cat > pages/login.vue << 'EOF'
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
EOF

git add .
git commit -m "feat: login page with form validation and simulated authentication flow"
echo "✅ Commit 11 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 12 — Dashboard page
# ════════════════════════════════════════════════════════════════

mkdir -p pages/dashboard

cat > pages/dashboard/index.vue << 'EOF'
<script setup lang="ts">
import { useFavoritesStore } from '~/stores/favorites'
import type { Character } from '~/types/character'

definePageMeta({ middleware: 'auth' })

const favStore = useFavoritesStore()
const { characters, pending, error, currentPage, totalPages, hasNextPage, hasPrevPage, fetchCharacters, retry, nextPage, prevPage, search } = useCharacters()

onMounted(() => fetchCharacters(1))

function onSearch(query: string) { search(query) }
function onToggleFavorite(character: Character) { favStore.toggleFavorite(character) }
</script>
<template>
  <div class="min-h-screen bg-gray-900">
    <AppNavbar />
    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6">
      <div class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-white">Characters</h1>
          <p class="mt-1 text-sm text-gray-400">Browse the multiverse's finest inhabitants</p>
        </div>
        <SearchBar @search="onSearch" />
      </div>
      <Transition name="fade">
        <UiAppSpinner v-if="pending" message="Fetching characters from the multiverse..." />
      </Transition>
      <Transition name="fade">
        <div v-if="error && !pending" class="flex flex-col items-center gap-4 py-20 text-center">
          <span class="text-5xl">{{ error.includes('No characters') ? '🔍' : '⚠️' }}</span>
          <p class="text-gray-400">{{ error }}</p>
          <button v-if="!error.includes('No characters')" class="mt-2 rounded-lg border border-portal-green px-5 py-2 text-sm font-medium text-portal-green transition-colors duration-200 hover:bg-portal-green hover:text-gray-900" @click="retry">Try again</button>
        </div>
      </Transition>
      <Transition name="fade">
        <div v-if="!pending && !error && characters.length">
          <TransitionGroup name="card-list" tag="div" class="grid grid-cols-1 gap-5 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
            <CharacterCard v-for="character in characters" :key="character.id" :character="character" :is-favorite="favStore.isFavorite(character.id)" @toggle-favorite="onToggleFavorite" />
          </TransitionGroup>
          <div class="mt-10">
            <Pagination :current-page="currentPage" :total-pages="totalPages" :has-prev="hasPrevPage" :has-next="hasNextPage" @prev="prevPage" @next="nextPage" />
          </div>
        </div>
      </Transition>
    </main>
  </div>
</template>
EOF

git add .
git commit -m "feat: dashboard page — character grid, search, pagination and error handling with retry"
echo "✅ Commit 12 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 13 — Favorites page
# ════════════════════════════════════════════════════════════════

cat > pages/dashboard/favorites.vue << 'EOF'
<script setup lang="ts">
import { useFavoritesStore } from '~/stores/favorites'
import type { Character } from '~/types/character'

definePageMeta({ middleware: 'auth' })

const favStore = useFavoritesStore()
function onToggleFavorite(character: Character) { favStore.toggleFavorite(character) }
function clearAll() { if (confirm('Remove all favorites?')) favStore.clearFavorites() }
</script>
<template>
  <div class="min-h-screen bg-gray-900">
    <AppNavbar />
    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6">
      <div class="mb-8 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-bold text-white">My Favorites</h1>
          <p class="mt-1 text-sm text-gray-400">{{ favStore.favoritesCount }} character{{ favStore.favoritesCount !== 1 ? 's' : '' }} saved</p>
        </div>
        <UiAppButton v-if="favStore.favoritesCount > 0" variant="danger" @click="clearAll">Clear all</UiAppButton>
      </div>
      <Transition name="fade">
        <div v-if="favStore.favoritesCount === 0" class="flex flex-col items-center gap-4 py-24 text-center">
          <span class="text-6xl">💔</span>
          <h2 class="text-lg font-semibold text-gray-300">No favorites yet</h2>
          <p class="text-sm text-gray-500">Go to the Characters page and click the ❤️ on a card to save it here.</p>
          <NuxtLink to="/dashboard" class="mt-2 text-sm font-medium text-portal-green underline-offset-4 hover:underline">Browse characters →</NuxtLink>
        </div>
      </Transition>
      <Transition name="fade">
        <TransitionGroup v-if="favStore.favoritesCount > 0" name="card-list" tag="div" class="grid grid-cols-1 gap-5 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
          <CharacterCard v-for="character in favStore.favorites" :key="character.id" :character="character" :is-favorite="true" @toggle-favorite="onToggleFavorite" />
        </TransitionGroup>
      </Transition>
    </main>
  </div>
</template>
EOF

git add .
git commit -m "feat: favorites page with empty state and clear all action"
echo "✅ Commit 13 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 14 — Tests
# ════════════════════════════════════════════════════════════════

mkdir -p tests/stores tests/composables

cat > tests/stores/auth.test.ts << 'EOF'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '~/stores/auth'

const localStorageMock = (() => {
  let store: Record<string, string> = {}
  return {
    getItem: (key: string) => store[key] ?? null,
    setItem: (key: string, value: string) => { store[key] = value },
    removeItem: (key: string) => { delete store[key] },
    clear: () => { store = {} },
  }
})()
Object.defineProperty(globalThis, 'localStorage', { value: localStorageMock })
vi.stubGlobal('import', { meta: { client: true } })

describe('useAuthStore', () => {
  beforeEach(() => { setActivePinia(createPinia()); localStorageMock.clear() })

  it('starts unauthenticated', () => {
    const store = useAuthStore()
    expect(store.isAuthenticated).toBe(false)
    expect(store.token).toBeNull()
  })
  it('returns false for invalid email', () => {
    expect(useAuthStore().login('not-an-email', 'password123')).toBe(false)
  })
  it('returns false when password is 6 chars or less', () => {
    expect(useAuthStore().login('rick@morty.com', '123456')).toBe(false)
  })
  it('authenticates with valid credentials', () => {
    const store = useAuthStore()
    expect(store.login('rick@morty.com', 'wubbalubbadubdub')).toBe(true)
    expect(store.isAuthenticated).toBe(true)
    expect(store.userEmail).toBe('rick@morty.com')
  })
  it('clears state on logout', () => {
    const store = useAuthStore()
    store.login('rick@morty.com', 'wubbalubbadubdub')
    store.logout()
    expect(store.isAuthenticated).toBe(false)
    expect(store.token).toBeNull()
  })
})
EOF

cat > tests/stores/favorites.test.ts << 'EOF'
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useFavoritesStore } from '~/stores/favorites'
import type { Character } from '~/types/character'

const mockChar = (id: number, name: string): Character => ({
  id, name, status: 'Alive', species: 'Human', type: '', gender: 'Male',
  origin: { name: 'Earth', url: '' }, location: { name: 'Earth', url: '' },
  image: '', episode: [], url: '', created: '',
})

const localStorageMock = (() => {
  let store: Record<string, string> = {}
  return {
    getItem: (key: string) => store[key] ?? null,
    setItem: (key: string, value: string) => { store[key] = value },
    removeItem: (key: string) => { delete store[key] },
    clear: () => { store = {} },
  }
})()
Object.defineProperty(globalThis, 'localStorage', { value: localStorageMock })

describe('useFavoritesStore', () => {
  beforeEach(() => { setActivePinia(createPinia()); localStorageMock.clear() })

  it('starts empty', () => { expect(useFavoritesStore().favoritesCount).toBe(0) })
  it('adds a character', () => {
    const store = useFavoritesStore()
    store.toggleFavorite(mockChar(1, 'Rick'))
    expect(store.isFavorite(1)).toBe(true)
  })
  it('removes on second toggle', () => {
    const store = useFavoritesStore()
    store.toggleFavorite(mockChar(1, 'Rick'))
    store.toggleFavorite(mockChar(1, 'Rick'))
    expect(store.isFavorite(1)).toBe(false)
  })
  it('clearFavorites removes all', () => {
    const store = useFavoritesStore()
    store.toggleFavorite(mockChar(1, 'Rick'))
    store.toggleFavorite(mockChar(2, 'Morty'))
    store.clearFavorites()
    expect(store.favoritesCount).toBe(0)
  })
  it('removeFavorite removes only specified id', () => {
    const store = useFavoritesStore()
    store.toggleFavorite(mockChar(1, 'Rick'))
    store.toggleFavorite(mockChar(2, 'Morty'))
    store.removeFavorite(1)
    expect(store.isFavorite(2)).toBe(true)
    expect(store.isFavorite(1)).toBe(false)
  })
})
EOF

cat > tests/composables/useCharacters.test.ts << 'EOF'
import { describe, it, expect, vi, beforeEach } from 'vitest'

const mockResponse = {
  info: { count: 2, pages: 1, next: null, prev: null },
  results: [
    { id: 1, name: 'Rick Sanchez', status: 'Alive', species: 'Human', image: '', location: { name: 'Earth' }, episode: [] },
    { id: 2, name: 'Morty Smith', status: 'Alive', species: 'Human', image: '', location: { name: 'Earth' }, episode: [] },
  ],
}

vi.stubGlobal('$fetch', vi.fn().mockResolvedValue(mockResponse))

import { ref, computed } from 'vue'
vi.stubGlobal('ref', ref)
vi.stubGlobal('computed', computed)

import { useCharacters } from '~/composables/useCharacters'

describe('useCharacters', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.stubGlobal('$fetch', vi.fn().mockResolvedValue(mockResponse))
  })

  it('starts with empty state', () => {
    const { characters, pending, error } = useCharacters()
    expect(characters.value).toHaveLength(0)
    expect(pending.value).toBe(false)
    expect(error.value).toBeNull()
  })
  it('fetches and populates characters', async () => {
    const { characters, fetchCharacters } = useCharacters()
    await fetchCharacters(1)
    expect(characters.value).toHaveLength(2)
  })
  it('hasNextPage is false when next is null', async () => {
    const { hasNextPage, fetchCharacters } = useCharacters()
    await fetchCharacters(1)
    expect(hasNextPage.value).toBe(false)
  })
  it('sets not-found error on 404', async () => {
    vi.stubGlobal('$fetch', vi.fn().mockRejectedValue({ statusCode: 404 }))
    const { error, fetchCharacters } = useCharacters()
    await fetchCharacters(1, 'xyz')
    expect(error.value).toContain('No characters found')
  })
  it('sets generic error on network failure', async () => {
    vi.stubGlobal('$fetch', vi.fn().mockRejectedValue(new Error('Network error')))
    const { error, fetchCharacters } = useCharacters()
    await fetchCharacters(1)
    expect(error.value).toContain('Something went wrong')
  })
})
EOF

git add .
git commit -m "test: unit tests for auth store, favorites store and useCharacters composable"
echo "✅ Commit 14 done"

# ════════════════════════════════════════════════════════════════
# COMMIT 15 — README
# ════════════════════════════════════════════════════════════════

cat > README.md << 'EOF'
# 🛸 Rick & Morty Dashboard

A character management dashboard built with **Nuxt 3**, **Vue 3**, **Pinia** and **Tailwind CSS** as a technical assessment for Óptima Cultura.

## 🚀 Getting started

### Prerequisites
- Node.js v18 or above

### Installation

```bash
git clone https://github.com/your-username/rick-morty-dashboard.git
cd rick-morty-dashboard
npm install
npm run dev
```

Open **http://localhost:3000** — use any valid email and a password longer than 6 characters to log in.

### Tests

```bash
npm test
```

## 🗂 Architecture

```
├── assets/css/          # Tailwind + page/card/fade transitions
├── components/
│   ├── ui/              # Dumb UI primitives (AppButton, AppInput, AppSpinner)
│   ├── CharacterCard.vue
│   ├── SearchBar.vue    # 400ms debounced search
│   ├── Pagination.vue
│   └── AppNavbar.vue
├── composables/
│   └── useCharacters.ts # API logic, pagination, search and retry
├── middleware/
│   └── auth.ts          # Protects /dashboard routes
├── pages/
│   ├── login.vue
│   └── dashboard/
│       ├── index.vue    # Character grid
│       └── favorites.vue
├── stores/
│   ├── auth.ts          # Simulated auth with localStorage
│   └── favorites.ts     # Favorites with localStorage persistence
├── tests/               # Vitest unit tests
└── types/character.ts   # TypeScript interfaces
```

## ✅ Features

- Simulated login (any valid email + password > 6 chars)
- Route middleware protecting dashboard
- Character grid with image, name and status
- Debounced search by name
- Previous / Next pagination
- Add/remove favorites with heart button
- Favorites persist across navigation and page refresh
- Loading states, error messages and retry button
- Responsive layout (mobile + desktop)
- Page and card list transitions
- TypeScript throughout
- Unit tests with Vitest

## 🌐 API

[Rick and Morty API](https://rickandmortyapi.com/) — `GET /api/character?page=N&name=query`
EOF

git add .
git commit -m "docs: README with setup instructions, architecture overview and feature checklist"
echo "✅ Commit 15 done"

echo ""
echo "🎉 All 15 commits created successfully!"
echo "Run 'git log --oneline' to verify the history."

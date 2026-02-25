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

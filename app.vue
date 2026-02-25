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

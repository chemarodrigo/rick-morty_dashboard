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

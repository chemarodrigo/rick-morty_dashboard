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

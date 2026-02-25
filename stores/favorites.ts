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

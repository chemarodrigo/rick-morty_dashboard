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

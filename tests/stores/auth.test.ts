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

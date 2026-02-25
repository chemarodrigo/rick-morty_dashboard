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

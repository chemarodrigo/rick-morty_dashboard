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

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

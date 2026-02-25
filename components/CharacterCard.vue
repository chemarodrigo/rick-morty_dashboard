<script setup lang="ts">
import type { Character } from '~/types/character'

interface Props { character: Character; isFavorite: boolean }
const props = defineProps<Props>()
const emit = defineEmits<{ (e: 'toggle-favorite', character: Character): void }>()

const statusColour: Record<string, string> = { Alive: 'bg-portal-green', Dead: 'bg-red-500', unknown: 'bg-gray-500' }
</script>
<template>
  <article class="group relative flex flex-col overflow-hidden rounded-xl border border-gray-700 bg-gray-800 shadow-md transition-all duration-300 hover:-translate-y-1 hover:border-portal-green hover:shadow-portal-green/20 hover:shadow-lg">
    <div class="relative overflow-hidden">
      <img :src="props.character.image" :alt="props.character.name" class="h-48 w-full object-cover transition-transform duration-300 group-hover:scale-105" loading="lazy" />
      <button :aria-label="isFavorite ? 'Remove from favorites' : 'Add to favorites'" class="absolute right-2 top-2 rounded-full bg-gray-900/80 p-1.5 backdrop-blur-sm transition-transform duration-200 hover:scale-110 focus:outline-none" @click.stop="emit('toggle-favorite', props.character)">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" :fill="isFavorite ? '#97CE4C' : 'none'" :stroke="isFavorite ? '#97CE4C' : '#9CA3AF'" stroke-width="2" class="h-5 w-5 transition-colors duration-200">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
        </svg>
      </button>
    </div>
    <div class="flex flex-1 flex-col gap-2 p-4">
      <h3 class="truncate text-base font-bold text-white" :title="props.character.name">{{ props.character.name }}</h3>
      <div class="flex items-center gap-2">
        <span :class="statusColour[props.character.status] ?? 'bg-gray-500'" class="h-2.5 w-2.5 rounded-full" />
        <span class="text-sm text-gray-300">{{ props.character.status }} — {{ props.character.species }}</span>
      </div>
      <div class="mt-auto pt-2 text-xs text-gray-500">
        <p class="font-medium uppercase tracking-wide text-gray-400">Last seen</p>
        <p class="truncate text-gray-300">{{ props.character.location.name }}</p>
      </div>
    </div>
  </article>
</template>

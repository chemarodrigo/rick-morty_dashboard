<script setup lang="ts">
const emit = defineEmits<{ (e: 'search', query: string): void }>()
const query = ref('')
let debounceTimer: ReturnType<typeof setTimeout> | null = null

function onInput() {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => emit('search', query.value), 400)
}
function clearSearch() { query.value = ''; emit('search', '') }
</script>
<template>
  <div class="relative w-full max-w-md">
    <svg class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
      <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
    </svg>
    <input v-model="query" type="text" placeholder="Search characters..." class="w-full rounded-lg border border-gray-600 bg-gray-800 py-2.5 pl-10 pr-10 text-sm text-white placeholder-gray-500 outline-none transition-colors duration-200 focus:border-portal-green" @input="onInput" />
    <Transition name="fade">
      <button v-if="query" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white" aria-label="Clear search" @click="clearSearch">
        <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </Transition>
  </div>
</template>

<script setup lang="ts">
interface Props { currentPage: number; totalPages: number; hasPrev: boolean; hasNext: boolean }
defineProps<Props>()
const emit = defineEmits<{ (e: 'prev'): void; (e: 'next'): void }>()
</script>
<template>
  <div class="flex items-center justify-center gap-4">
    <button :disabled="!hasPrev" class="flex items-center gap-2 rounded-lg border border-gray-600 bg-gray-800 px-4 py-2 text-sm font-medium text-gray-300 transition-all duration-200 hover:border-portal-green hover:text-portal-green disabled:cursor-not-allowed disabled:opacity-40" @click="emit('prev')">
      <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" /></svg>
      Previous
    </button>
    <span class="text-sm text-gray-400">Page <span class="font-bold text-white">{{ currentPage }}</span> of <span class="font-bold text-white">{{ totalPages }}</span></span>
    <button :disabled="!hasNext" class="flex items-center gap-2 rounded-lg border border-gray-600 bg-gray-800 px-4 py-2 text-sm font-medium text-gray-300 transition-all duration-200 hover:border-portal-green hover:text-portal-green disabled:cursor-not-allowed disabled:opacity-40" @click="emit('next')">
      Next
      <svg class="h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" /></svg>
    </button>
  </div>
</template>

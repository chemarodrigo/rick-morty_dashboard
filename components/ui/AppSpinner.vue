<script setup lang="ts">
interface Props { message?: string }
withDefaults(defineProps<Props>(), { message: 'Loading...' })
</script>
<template>
  <div class="flex flex-col items-center justify-center gap-4 py-20">
    <svg class="h-12 w-12 animate-spin text-portal-green" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
    </svg>
    <p class="text-sm text-gray-400">{{ message }}</p>
  </div>
</template>

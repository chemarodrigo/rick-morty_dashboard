<script setup lang="ts">
interface Props {
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost'
  disabled?: boolean
  loading?: boolean
  type?: 'button' | 'submit' | 'reset'
}
const props = withDefaults(defineProps<Props>(), {
  variant: 'primary', disabled: false, loading: false, type: 'button',
})
const variantClasses: Record<string, string> = {
  primary: 'bg-portal-green text-gray-900 hover:brightness-110 focus-visible:ring-portal-green',
  secondary: 'bg-portal-blue text-white hover:brightness-110 focus-visible:ring-portal-blue',
  danger: 'bg-red-600 text-white hover:bg-red-700 focus-visible:ring-red-500',
  ghost: 'bg-transparent text-gray-300 border border-gray-600 hover:border-portal-green hover:text-portal-green focus-visible:ring-gray-500',
}
</script>
<template>
  <button
    :type="props.type"
    :disabled="props.disabled || props.loading"
    :class="[variantClasses[props.variant], 'inline-flex items-center justify-center gap-2 rounded-lg px-4 py-2 text-sm font-semibold transition-all duration-200 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-offset-gray-900 disabled:opacity-50 disabled:cursor-not-allowed']"
  >
    <svg v-if="props.loading" class="h-4 w-4 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
    </svg>
    <slot />
  </button>
</template>

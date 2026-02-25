<script setup lang="ts">
interface Props {
  label?: string
  type?: 'text' | 'email' | 'password'
  placeholder?: string
  error?: string
  id?: string
}
withDefaults(defineProps<Props>(), { label: '', type: 'text', placeholder: '', error: '', id: '' })
const model = defineModel<string>({ default: '' })
</script>
<template>
  <div class="flex flex-col gap-1">
    <label v-if="label" :for="id" class="text-sm font-medium text-gray-300">{{ label }}</label>
    <input
      :id="id" v-model="model" :type="type" :placeholder="placeholder"
      :class="['w-full rounded-lg border bg-gray-800 px-4 py-2.5 text-sm text-white placeholder-gray-500 transition-colors duration-200 outline-none', error ? 'border-red-500 focus:border-red-400' : 'border-gray-600 focus:border-portal-green']"
    />
    <Transition name="fade">
      <p v-if="error" class="text-xs text-red-400">{{ error }}</p>
    </Transition>
  </div>
</template>

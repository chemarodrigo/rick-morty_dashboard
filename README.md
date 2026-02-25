# 🛸 Rick & Morty Dashboard

A character management dashboard built with **Nuxt 3**, **Vue 3**, **Pinia** and **Tailwind CSS**

## 🚀 Getting started

### Prerequisites
- Node.js v18 or above

### Installation

```bash
git clone https://github.com/chemarodrigo/rick-morty_dashboard.git
cd rick-morty-dashboard
npm install
npm run dev
```

Open **http://localhost:3000** — use any valid email and a password longer than 6 characters to log in.

### Tests

```bash
npm test
```

## 🗂 Architecture

```
├── assets/css/          # Tailwind + page/card/fade transitions
├── components/
│   ├── ui/              # Dumb UI primitives (AppButton, AppInput, AppSpinner)
│   ├── CharacterCard.vue
│   ├── SearchBar.vue    # 400ms debounced search
│   ├── Pagination.vue
│   └── AppNavbar.vue
├── composables/
│   └── useCharacters.ts # API logic, pagination, search and retry
├── middleware/
│   └── auth.ts          # Protects /dashboard routes
├── pages/
│   ├── login.vue
│   └── dashboard/
│       ├── index.vue    # Character grid
│       └── favorites.vue
├── stores/
│   ├── auth.ts          # Simulated auth with localStorage
│   └── favorites.ts     # Favorites with localStorage persistence
├── tests/               # Vitest unit tests
└── types/character.ts   # TypeScript interfaces
```

## ✅ Features

- Simulated login (any valid email + password > 6 chars)
- Route middleware protecting dashboard
- Character grid with image, name and status
- Debounced search by name
- Previous / Next pagination
- Add/remove favorites with heart button
- Favorites persist across navigation and page refresh
- Loading states, error messages and retry button
- Responsive layout (mobile + desktop)
- Page and card list transitions
- TypeScript throughout
- Unit tests with Vitest

## 🌐 API

[Rick and Morty API](https://rickandmortyapi.com/) — `GET /api/character?page=N&name=query`

# 🛸 Rick & Morty Dashboard (ESPAÑOL)

Panel de gestión de personajes construido con **Nuxt 3**, **Vue 3**, **Pinia** y **Tailwind CSS** como prueba técnica.

## 🚀 Primeros pasos

### Requisitos previos
- Node.js v18 o superior

### Instalación

```bash
git clone https://github.com/chemarodrigo/rick-morty_dashboard.git
cd rick-morty-dashboard
npm install
npm run dev
```

Abre **http://localhost:3000** — usa cualquier email válido y una contraseña de más de 6 caracteres para iniciar sesión.

### Tests

```bash
npm test
```

## 🗂 Arquitectura

```
├── assets/css/          # Tailwind + transiciones de página, tarjeta y fade
├── components/
│   ├── ui/              # Componentes de UI básicos (AppButton, AppInput, AppSpinner)
│   ├── CharacterCard.vue
│   ├── SearchBar.vue    # Búsqueda con debounce de 400ms
│   ├── Pagination.vue
│   └── AppNavbar.vue
├── composables/
│   └── useCharacters.ts # Lógica de API, paginación, búsqueda y reintento
├── middleware/
│   └── auth.ts          # Protege las rutas de /dashboard
├── pages/
│   ├── login.vue
│   └── dashboard/
│       ├── index.vue    # Grid de personajes
│       └── favorites.vue
├── stores/
│   ├── auth.ts          # Autenticación simulada con localStorage
│   └── favorites.ts     # Favoritos con persistencia en localStorage
├── tests/               # Tests unitarios con Vitest
└── types/character.ts   # Interfaces TypeScript
```

## ✅ Funcionalidades

- Inicio de sesión simulado (cualquier email válido + contraseña de más de 6 caracteres)
- Middleware de rutas que protege el dashboard
- Grid de personajes con imagen, nombre y estado
- Búsqueda por nombre con debounce
- Paginación con botones Anterior / Siguiente
- Añadir y eliminar favoritos con botón de corazón
- Favoritos persistentes entre navegaciones y recargas de página
- Estados de carga, mensajes de error y botón de reintento
- Diseño responsive (móvil y escritorio)
- Transiciones de página y de lista de tarjetas
- TypeScript en todo el proyecto
- Tests unitarios con Vitest

## 🌐 API

[Rick and Morty API](https://rickandmortyapi.com/) — `GET /api/character?page=N&name=query`

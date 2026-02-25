# 🛸 Rick & Morty Dashboard

A character management dashboard built with **Nuxt 3**, **Vue 3**, **Pinia** and **Tailwind CSS** as a technical assessment for Óptima Cultura.

## 🚀 Getting started

### Prerequisites
- Node.js v18 or above

### Installation

```bash
git clone https://github.com/your-username/rick-morty-dashboard.git
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

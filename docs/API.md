# API Documentation (RealWorld / Conduit)

This project implements the **RealWorld (Conduit)** backend API specification.

- RealWorld Project: https://github.com/gothinkster/realworld
- Backend API Spec: https://gothinkster.github.io/realworld/docs/specs/backend-specs/endpoints

## Base URL

By default, the Rails server runs at:

- `http://127.0.0.1:3000`

API routes are namespaced under:

- `/api`

Example:

- `GET http://127.0.0.1:3000/api/articles`

## Authentication

Authentication is typically done using **JWT** via the `Authorization` header:

Authorization: Token <jwt>

markdown
Copy code

> Note: Exact JWT secret/config depends on the app configuration.

## Common Response Shape

Most endpoints return JSON using the shapes defined in the RealWorld spec.

## Endpoints Overview

### Users & Auth

- `POST /api/users` — Register
- `POST /api/users/login` — Login
- `GET /api/user` — Current user (auth required)
- `PUT /api/user` — Update current user (auth required)

### Profiles

- `GET /api/profiles/:username` — Get profile
- `POST /api/profiles/:username/follow` — Follow user (auth required)
- `DELETE /api/profiles/:username/follow` — Unfollow user (auth required)

### Articles

- `GET /api/articles` — List articles (filters + pagination)
- `GET /api/articles/feed` — Feed (auth required)
- `POST /api/articles` — Create (auth required)
- `GET /api/articles/:slug` — Get by slug
- `PUT /api/articles/:slug` — Update (auth required)
- `DELETE /api/articles/:slug` — Delete (auth required)

### Favorites

- `POST /api/articles/:slug/favorite` — Favorite (auth required)
- `DELETE /api/articles/:slug/favorite` — Unfavorite (auth required)

### Comments

- `GET /api/articles/:slug/comments` — List comments
- `POST /api/articles/:slug/comments` — Add comment (auth required)
- `DELETE /api/articles/:slug/comments/:id` — Delete comment (auth required)

### Tags

- `GET /api/tags` — List tags

## Pagination & Filters

The spec supports:

- Pagination via `limit` and `offset`
- Filtering articles by `tag`, `author`, and `favorited`

Example:

GET /api/articles?tag=rails&limit=10&offset=0

markdown
Copy code

## Local Testing Tips

- Use Postman/Insomnia or `curl`
- If you’re using the official RealWorld frontends, point them to your base URL.

## License

See the repository LICENSE (if present).

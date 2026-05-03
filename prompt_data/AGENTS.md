# AGENTS.md — AidatPanel Backend

## Must-follow Constraints

- **Phase-locked:** Never implement outside current Faz. If user asks, respond: "Bu Faz 1 disi. Faz 2'de yapilacak."
- **Zod first:** All POST/PUT routes must use `validateMiddleware` before controller. No raw `req.body` passthrough.
- **Transactions:** Multi-step DB operations (join flow, bulk dues, invite code + user creation) must use Prisma `$transaction`.
- **JWT payload only:** `authMiddleware` must not DB-lookup. `req.user = { id, role }` from token only.
- **Response envelope:** Every API response must be `{ success: boolean, data?: T, message?: string }`.
- **No pagination yet:** Faz 1 only. Do not add `skip`/`take` to list endpoints unless explicitly asked.

## Validation Before Finishing

- [ ] All new POST/PUT routes wrapped with Zod validation
- [ ] Multi-step DB ops use `$transaction`
- [ ] `npm test` passes (auth + building + apartment tests)
- [ ] No `console.log` in production code; use `logger` util

## Repo-specific Conventions

- **Service pattern:** Controller calls Service. Service calls Prisma. No Prisma in controller.
- **Error handling:** All errors flow through `errorHandler` middleware. Services throw, controllers `next(error)`.
- **Route prefix:** All routes mounted at `/api/v1/*` in `index.js`.
- **File naming:** Singular for controllers (`authController.js`), plural for routes (`authRoutes.js`).

## Important Locations

- `backend/src/middlewares/validateMiddleware.js` — does not exist yet. Must be created.
- `backend/src/validators/` — Zod schemas live here.
- `backend/src/services/` — All DB logic isolated here.
- `backend/prisma/schema.prisma` — Source of truth. Check before assuming field names.

## Change Safety Rules

- Preserve backward compatibility on existing endpoints.
- New fields: optional by default, required only with migration plan.
- Never drop tables/columns without explicit user approval.
- `.env` changes must be documented in `.env.example`.

## Known Gotchas

- `authMiddleware` currently has a commented-out DB lookup. Do not uncomment it.
- `join` controller in `authControllers.js` is commented out. Needs `$transaction` when re-enabled.
- Rate limiter uses MemoryStore — fine for Faz 1, but will fail under PM2 cluster (Faz 3 concern).
- `mobile/` folder was deleted. Do not recreate it.

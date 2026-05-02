# AGENTS.md

## Must-follow constraints

- **Backend is ES Modules.** Every `import` path must end with `.js` (e.g., `../utils/foo.js`). Omitting the extension crashes the server.
- **Database adapter is PrismaPg.** Uses `pg.Pool` in `src/config/db.js`. Local dev needs a standard PostgreSQL `DATABASE_URL`.
- **All API routes live under `/api/v1`.** New routes must be registered in `index.js` under this prefix.
- **Zod schemas are centralized in `src/middlewares/validate.js`.** Add new endpoint schemas there; never inline Zod validation in controllers or routes.
- **Controllers must call service functions.** Never write Prisma queries directly inside controllers. Service layer is the single point for DB logic.
- **Register auto-creates MANAGER role.** Normal registration always yields `role: MANAGER`. RESIENT role is only created through the invite-code flow (`join`), which is currently disabled.
- **Login endpoint accepts `identifier` (email or phone).** Sends `where: { email }` if `identifier` contains '@', otherwise `where: { phone }`. Phone must be unique (`@unique` in schema) for this to work.
- **Building/apartment endpoints enforce manager ownership.** Every service query must include `managerId` filter from `req.user.id`. Skipping this is an IDOR vulnerability.

## Repo-specific conventions

- **Backend error responses use this shape:** `{ success: boolean, message: string, data?: any }`. Match this exact shape in new controllers. Never use `error:` key in responses — always `message:`.
- **Global error handler catches Zod, Prisma, and JWT errors.** Throwing or calling `next(err)` in controllers routes to `src/middlewares/errorHandler.js`. Returning `res.status(500).json(...)` manually bypasses it — avoid manual 500 responses in controllers.
- **Express 5 auto-catches async errors.** Do not wrap controllers in `try/catch`. Let errors bubble to global handler. Manual `try/catch` only for specific business logic (e.g., "not found" checks).
- **Mobile API base URL is production (`api.aidatpanel.com:2773`).** When implementing new mobile features, add a localhost fallback or ask before assuming local backend.
- **Mobile uses Clean Architecture:** `data/` (datasources, models, repositories), `domain/` (entities), `presentation/` (providers, screens, widgets). Keep this boundary.
- **Flutter `supportedLocales` is hardcoded to `[Locale('en', 'US')]`** in `main.dart`. Any Turkish UI text added without updating `supportedLocales` and adding ARB files in `lib/l10n/` will not render correctly.

## Important locations (only non-obvious)

- `mobile/lib/core/network/dio_client.dart` — Interceptor handles 401 refresh-token retry. Any new endpoint that returns 401 must not break this flow.
- `mobile/lib/core/constants/api_constants.dart` — Endpoint paths are constants. Update here when backend routes change.
- `backend/src/middlewares/validate.js` — Single source of truth for all Zod schemas.
- `backend/prisma/schema.prisma` — InviteCode, Due, Expense, Ticket, Notification models exist but have no routes/services yet. Don't assume endpoints exist.

## Known gotchas

- **`join` controller in `authControllers.js` is fully commented out.** Do not uncomment without also enabling the route in `authRoutes.js` and verifying invite-code validation in `authService.js`.
- **Nunito font is declared in `AppTypography` but never loaded in `pubspec.yaml`.** Adding custom text styles without registering the font asset will silently fall back to system default.
- **No automated tests exist.** Manual endpoint verification is required before considering any feature complete.
- **Backend port comes from `process.env.PORT`.** If `.env` is missing, the server starts on `undefined`. Always verify `.env` exists before `npm run dev`.

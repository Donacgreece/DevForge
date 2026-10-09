# DevForge MVP 0.1.0

A free, open-source (MIT), bilingual (Greek / English) coding-practice prototype for beginners through experienced developers.

## Features
- Responsive dark UI, dashboard, progress and practice browser
- Eight original JavaScript challenges (Easy / Medium / Hard)
- Search by title/topic and filter by difficulty
- Editable code, isolated browser Worker test execution and per-test feedback
- Reset, optional hints, XP and solved progress
- Persistent drafts, language preference and solved challenges in localStorage
- No account, paid service, API key, or backend required

## Requirements
Node.js 20.19+ or 22.12+, npm

## Run
```bash
npm install
npm run dev
```
Open the URL shown by Vite (usually http://localhost:5173).

Build: `npm run build`. Preview built site: `npm run preview`.

## Security / limits (IMPORTANT)
The browser Web Worker **is not a security boundary**. It keeps typical CPU-heavy code away from the UI thread and terminates after a timeout, but user JavaScript may access worker APIs, network, etc. This MVP should be used only as a local demo, never advertised as secure sandboxing for arbitrary hostile code. Do not send secrets into its worker. Test cases are visible in the frontend; scoring is not authoritative. Never use this mechanism for competitive contests or paid certifications.

There is **no real account/login, cloud syncing, database, server-side judge, hidden test secrecy, Monaco editor, lesson engine, or AI tutor yet**. The Learning Paths menu is deliberately marked as coming later.

## Production roadmap
1. Monorepo: `apps/web` React + `apps/api` Fastify + `apps/judge` isolated evaluation workers + `packages/problems`, `packages/i18n`.
2. Auth: secure session cookies, email verification, account deletion and GDPR compliance. PostgreSQL with versioned migrations. Tables `users`, `problems`, `problem_translations`, `test_cases`, `submissions`, `progress`, `learning_paths`, `lessons`, `audit_events`.
3. Judge: backend-only test cases. Redis queue, short-lived isolated containers or microVM workers with no outbound network, read-only filesystem, CPU/memory/time/process limits and concurrency quotas. Validate runtime images and capture limited logs.
4. Upgrade editor to Monaco, add TypeScript/Python/Java in isolated runners, improve accessibility (WCAG), add structured lessons and editorial content review.
5. Abuse controls, rate-limits, observability, moderation and challenge versioning; opt-in analytics and privacy-first metrics.
6. CI: typecheck, unit/integration tests, E2E workflow, security scanning, automated deployment. Track operational costs before promising unlimited usage.

## License
MIT. See LICENSE. Exercises in this demo are original examples; avoid copying LeetCode's proprietary exercise descriptions, editorial material, test suites or trademarked design.

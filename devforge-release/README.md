# DevForge · JavaScript Edition

A free, bilingual (English and Greek), open-source JavaScript practice experience.

## What's included

- 30 original JavaScript challenges with examples, hints and public test cases
- Browser-based challenge evaluator, separate Run and Submit flows
- 8 written JavaScript mini lessons, each paired with a challenge
- Independent JavaScript Playground and console output
- Dashboard, searchable challenge library, difficulty/topic/status filters
- XP, milestones, lesson progress, saved drafts, JSON backup and restore
- Responsive custom design, no login required
- Automatic GitHub Pages deployment at https://donacgreece.github.io/DevForge/

## Run locally

Install Node.js 22+, then:

```bash
npm install
npm run dev
```

## Production build

```bash
npm run build
```

## Deployment

GitHub Actions deploys on each push to `main`. In repository Settings > Pages select **GitHub Actions** as the source. Vite's `base` is `/DevForge/`.

## Important limitations

**Early public beta, not a production-grade online judge.** The evaluator uses a browser Web Worker and dynamic JavaScript execution. A Web Worker is NOT a secure sandbox, and it can make network requests. Never rely on this model to protect secrets, to grade untrusted submissions authoritatively, or to run competitions. All tests are visible to the client. User progress is local and can be manipulated. For robust public execution use a hardened, isolated backend service with dedicated sandboxing and strict network/CPU/RAM/filesystem policies.

The code editor currently uses a focused monospace textarea, not Monaco. No accounts, cloud sync, community, private tests or AI tutor are claimed. Avoid promising those features until delivered. More curriculum and exercises require editorial and QA review.

## Open source

MIT license. Contributions welcome. Please write original exercises rather than importing copyrighted content from other challenge platforms.

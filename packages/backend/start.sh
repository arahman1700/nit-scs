#!/bin/sh
set -e
echo "==> Running Prisma migrations..."
npx prisma migrate deploy 2>&1
echo "==> Seeding database..."
node dist/seed/seed.js 2>&1 || echo "INFO: Seed skipped (may already be seeded)"
echo "==> Starting server..."
exec node dist/index.js

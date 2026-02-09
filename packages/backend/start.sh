#!/bin/sh
echo "==> Syncing database schema with prisma db push..."
npx prisma db push --skip-generate 2>&1 || {
  echo "ERROR: prisma db push failed. Cannot start without correct schema."
  exit 1
}
echo "==> Database schema is up to date"

echo "==> Resolving migration history..."
npx prisma migrate resolve --applied 20260208143513_initial_v2_schema 2>&1 || true
npx prisma migrate resolve --applied 20260209123353_add_attachments_and_user_views 2>&1 || true

echo "==> Seeding database..."
node dist/seed/seed.js 2>&1 || echo "INFO: Seed skipped (may already be seeded)"

echo "==> Starting server..."
exec node dist/index.js

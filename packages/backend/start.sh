#!/bin/sh
echo "==> Running Prisma migrations..."
if npx prisma migrate deploy 2>&1; then
  echo "==> Migrations applied successfully"
else
  echo "==> migrate deploy failed, falling back to db push..."
  npx prisma db push --accept-data-loss 2>&1 || {
    echo "ERROR: Both migrate deploy and db push failed. Cannot start."
    exit 1
  }
  echo "==> db push completed successfully"
fi
echo "==> Seeding database..."
node dist/seed/seed.js 2>&1 || echo "INFO: Seed skipped (may already be seeded)"
echo "==> Starting server..."
exec node dist/index.js

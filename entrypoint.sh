#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
echo "Waiting for database..."
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USERNAME" -d "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "Postgres is up - executing migrations"

# Run database migrations
bundle exec rails db:migrate 2>/dev/null || true

# Seed database if needed
bundle exec rails db:seed 2>/dev/null || true

echo "Database setup complete"

# Execute the main command
exec "$@"

#! /bin/sh

# Wait a bit more for database to be fully ready
sleep 3

# Retry logic for database operations
MAX_RETRIES=5
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Attempting to prepare database (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)..."
  
  # If the database exists, migrate. Otherwise setup (create and migrate)
  if bundle exec rake db:migrate 2>/dev/null; then
    echo "Database migration successful!"
    break
  elif bundle exec rake db:create db:setup db:migrate 2>/dev/null; then
    echo "Database created and migrated successfully!"
    break
  else
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
      echo "Database operation failed, retrying in 5 seconds..."
      sleep 5
    else
      echo "Database preparation failed after $MAX_RETRIES attempts"
      exit 1
    fi
  fi
done

echo "Done!"

# Raise error if the following keys missing in .env
Dotenv.require_keys("DATABASE_URL", "REDIS_URL")

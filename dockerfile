# Simple Dockerfile (no multi-stage build)
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies first (better caching)

# Copy application code
COPY . .

# Expose port
ENV PORT=8080
EXPOSE 8080

# Start the application using gunicorn
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080", "--workers", "2"]

# Base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install dependencies
RUN pip install flask psycopg2

# Non-root user
RUN useradd -m appuser
USER appuser

# Expose port
EXPOSE 5000

# Entry point
CMD ["python", "app_v1.py"]

FROM python:3.9-slim

RUN apt-get update && apt-get install -y libpq-dev gcc

RUN pip install --upgrade pip

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir flask psycopg2-binary

EXPOSE 5000

CMD ["python", "app.py"]

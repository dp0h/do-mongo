FROM python:latest

RUN mkdir -p /app
WORKDIR /app
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 8002
CMD ["gunicorn", "-w", "1", "-b", ":8002", "app:app"]
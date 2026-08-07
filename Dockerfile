FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update -y && \
	apt-get install -y curl gcc default-libmysqlclient-dev pkg-config && \
	rm -rf /var/lib/apt/lists/*

RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "notesapp.wsgi:application"]


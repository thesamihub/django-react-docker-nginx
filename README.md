# Django + React + MySQL + Nginx with Docker

A full-stack Notes application containerized using Docker Compose. The project consists of a Django REST API backend, a React frontend, a MySQL database, and Nginx acting as a reverse proxy.

## Tech Stack

* **Backend:** Django, Django REST Framework
* **Frontend:** React
* **Database:** MySQL 8
* **Reverse Proxy:** Nginx
* **Containerization:** Docker & Docker Compose

## Project Architecture

```
                Browser
                   │
                   ▼
              Nginx (Port 80)
               /          \
              /            \
             ▼              ▼
     React Frontend     Django Backend
                               │
                               ▼
                            MySQL 8
```

## Features

* CRUD Notes API
* React frontend consuming Django REST API
* Reverse proxy with Nginx
* Dockerized backend, frontend, and database
* Persistent MySQL storage using Docker volumes
* Environment variable support

## Project Structure

```
.
├── api/
├── mynotes/                 # React application
├── nginx/
│   └── nginx.conf
├── notesapp/
├── Dockerfile               # Django Dockerfile
├── docker-compose.yml
├── requirements.txt
└── .env.example
```

## Environment Variables

Create a `.env` file from `.env.example`.

Example:

```env
DB_NAME=test_db
DB_USER=root
DB_PASSWORD=your_password
DB_HOST=db
DB_PORT=3306
```

## Running the Project

Clone the repository:

```bash
git clone https://github.com/thesamihub/django-react-docker-nginx.git
cd django-react-docker-nginx
```

Build and start the containers:

```bash
docker compose up --build
```

Apply Django migrations:

```bash
docker exec django_app_backend python manage.py migrate
```
Access the application:

* Frontend: http://localhost
* Backend API: http://localhost/api/

## Docker Services

| Service             | Description                                |
| ------------------- | ------------------------------------------ |
| django_app_backend  | Django REST API served with Gunicorn       |
| django_app_frontend | React application served with Nginx        |
| db                  | MySQL 8 database                           |
| nginx               | Reverse proxy routing frontend and backend |

## Nginx Routing

* `/` → React Frontend
* `/api/` → Django Backend

## Useful Docker Commands

Build images:

```bash
docker compose build
```

Start containers:

```bash
docker compose up -d
```

Stop containers:

```bash
docker compose down
```

Stop containers and remove volumes:

```bash
docker compose down -v
```

View logs:

```bash
docker compose logs -f
```

List running containers:

```bash
docker ps
```

## Future Improvements

* CI/CD with GitHub Actions
* HTTPS using Let's Encrypt
* Kubernetes deployment
* Docker Swarm support
* Redis integration

## License

This project is intended for learning and DevOps practice.


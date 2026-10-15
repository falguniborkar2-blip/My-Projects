# Flask Service Deployment

Homework for PA234 Infrastructural and Cloud Systems at Masaryk University. I took one small
Flask web service and deployed it in three different ways.

## The service (`pa234/`)

| Endpoint | Returns |
|---|---|
| `GET /` | redirects to `/status` |
| `GET /status` | software version, hostname and OS |
| `GET /status/date?timezone=Europe/Prague` | current date and time in the given timezone (input is sanitised) |
| `GET /status/uco` | student ID and name from environment variables |

Configuration comes from environment variables (`SOFTWARE_VERSION`, `CORS_ALLOWED_ORIGIN`, ...).

## 1. Linux server: uWSGI behind nginx

- [`uwsgi.ini`](uwsgi.ini): uWSGI runs the app with 2 processes x 4 threads on `127.0.0.1:8844`,
  logs to `/var/log/pa234-2026/`.
- [`deploy/nginx.conf`](deploy/nginx.conf): nginx listens on port 80 and forwards requests to
  uWSGI, passing the client IP and protocol headers.

## 2. Container image: [`Dockerfile`](Dockerfile)

- **Multi-stage build** on `python:3.12-alpine`: the builder stage compiles OpenSSL 3.6.0 from
  source with the MD2 algorithm enabled (a course requirement) and installs uWSGI; the runtime
  stage copies only what is needed.
- Runs as a **non-root user** (UID 1000) on port 8844.

```bash
docker build -t pa234 .
docker run -p 8844:8844 pa234
curl localhost:8844/status
```

## 3. Cloud VM with Terraform: [`terraform/`](terraform/)

Provisions the service on the e-INFRA CZ **OpenStack** cloud:

- a security group allowing SSH (22), HTTP (80) and HTTPS (443)
- a floating (public) IP
- a VM that is configured at boot with cloud-init (`user_data.sh`, not included in this repo)

All secrets (database password, JWT key, ...) are Terraform variables and are never stored in
the code. Cloud credentials go in a local `clouds.yaml`, which is git-ignored.

## Known issues / what I would improve

- `app.py` always enables the Werkzeug debugger. That is fine for development but must be
  switched off in production, because it allows running code from the browser.
- SSH is open to the whole internet (`0.0.0.0/0`); it should be limited to known IP ranges.

# --- STAGE 1: BUILDER ---
FROM python:3.12-alpine AS builder
RUN apk add --no-cache curl build-base perl linux-headers pcre-dev

# Build OpenSSL 3.6.0 with MD2 (Mandatory Homework Rule)
WORKDIR /openssl_build
RUN curl -LO https://www.openssl.org/source/openssl-3.6.0.tar.gz \
    && tar xzvf openssl-3.6.0.tar.gz && cd openssl-3.6.0 \
    && ./config enable-md2 shared --prefix=/opt/openssl \
    && make -j$(nproc) && make install_sw

# Install uwsgi and dependencies
WORKDIR /install
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install uwsgi -r requirements.txt

# --- STAGE 2: RUNTIME ---
FROM python:3.12-alpine
RUN apk add --no-cache pcre
ENV UCO="" \
    NAME="Falguni Borkar" \
    LIBCRYPTO_PATH="/opt/openssl/lib/libcrypto.so.3" \
    CORS_ALLOWED_ORIGIN="http://localhost:8844" \
    SOFTWARE_VERSION="1.0.0"

WORKDIR /app
COPY --from=builder /install /usr/local
COPY --from=builder /opt/openssl/lib/libcrypto.so.3 /opt/openssl/lib/
# Copy the app files you just unzipped locally
COPY . .

# Run as non-root user 1000
RUN adduser -u 1000 -D appuser && chown -R appuser:appuser /app
USER 1000
EXPOSE 8844
CMD ["uwsgi", "--ini", "uwsgi.ini", "--http", "0.0.0.0:8844"]
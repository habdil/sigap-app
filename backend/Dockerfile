FROM golang:1.24.3-alpine AS builder

WORKDIR /app

# Copy go mod dan sum files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build aplikasi
RUN go build -o main .

# Gunakan image yang lebih kecil untuk tahap akhir
FROM alpine:latest

WORKDIR /app

# Install dependency yang diperlukan
RUN apk add --no-cache tzdata ca-certificates

# Copy binary dari stage builder
COPY --from=builder /app/main .

# Port yang diexpose (sesuai dengan PORT=3000 di .env Anda)
EXPOSE 3000

# Menjalankan aplikasi
CMD ["./main"]
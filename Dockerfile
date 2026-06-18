FROM golang:alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Install necessary build tools
RUN apk add --no-cache gcc musl-dev

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the sadm app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o sadm_app ./cmd/sadm/main.go

# Build the sercod app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o sercod_app ./cmd/sercod/main.go

######## Start a new stage from scratch #######
FROM alpine:latest  

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /root/

# Copy the Pre-built binary files from the previous stage
COPY --from=builder /app/sadm_app .
COPY --from=builder /app/sercod_app .

# Expose ports (5001 for sadm, 5002 for sercod - configured via compose)
EXPOSE 5001 5002

# The entrypoint will be overridden in docker-compose depending on the service
CMD ["./sadm_app"]

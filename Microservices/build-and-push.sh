#!/bin/bash

# === CONFIGURATION ===
REGISTRY="harsh24314"   # Replace with your Docker Hub username or registry URL
TAG="${1:-v1}"                         # Change version tag as needed
SERVICES=("gateway-service" "order-service" "product-service" "user-service")  # Folder names for your microservices

# === SCRIPT START ===
echo "🔧 Building and pushing Docker images for services: ${SERVICES[*]}"

# Login to Docker (optional if already logged in)
echo "🔑 Logging in to Docker registry..."
docker login -u $REGISTRY || { echo "❌ Docker login failed!"; exit 1; }

for SERVICE in "${SERVICES[@]}"; do
  echo "🚀 Processing $SERVICE..."

  # Navigate into service folder
  cd "$SERVICE" || { echo "❌ Folder $SERVICE not found!"; exit 1; }

  # Build image
  IMAGE_NAME="$REGISTRY/$SERVICE:$TAG"
  echo "📦 Building image: $IMAGE_NAME"
  docker build -t "$IMAGE_NAME" .

  # Push image
  echo "⬆️ Pushing image: $IMAGE_NAME"
  docker push "$IMAGE_NAME"

  # Go back to root folder
  cd ..

  echo "✅ Done with $SERVICE"
  echo "----------------------------"
done

echo "🎉 All services built and pushed successfully!"

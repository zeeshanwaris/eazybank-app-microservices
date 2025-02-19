#!/bin/bash

# Define the base directory
BASE_DIR="/d/Intellij_Projects/Microservices/section9"

# List of microservices
SERVICES=("accounts" "cards" "loans" "configserver" "eurekaserver" "gatewayserver")

echo "Starting build and push process for microservices..."

# Loop through each microservice and run the build command
for SERVICE in "${SERVICES[@]}"; do
    SERVICE_DIR="$BASE_DIR/$SERVICE"
    IMAGE_NAME="zeeshan2424/$SERVICE:s9"  # Define the Docker image name

    if [[ -d "$SERVICE_DIR" && -f "$SERVICE_DIR/pom.xml" ]]; then
        echo "Building $SERVICE..."
        
        # Navigate to the microservice directory
        (cd "$SERVICE_DIR" && mvn clean compile jib:dockerBuild -DskipTests)

        # Tag the image (Jib builds images but doesn't push automatically)
        echo "Tagging image for $SERVICE..."
        docker tag "$SERVICE" "$IMAGE_NAME"

        # Push the image to Docker Hub
        echo "Pushing $SERVICE to Docker Hub..."
        docker push "$IMAGE_NAME"

    else
        echo "Skipping $SERVICE - Directory or pom.xml not found!"
    fi
done

echo "Build and push process completed!"

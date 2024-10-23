#!/bin/bash

ARCH=$(uname -m)
IMAGE_NAME="m8c-knulli"

# Detect architecture and set appropriate Dockerfile and build script
select_files() {
    case $ARCH in
    x86_64)
        echo "Building for x86_64 architecture..."
        DOCKERFILE="Dockerfile.x86_64"
        BUILD_SCRIPT="build_script.x86_64.sh"
        PLATFORM="linux/amd64"
        ;;
    arm64 | aarch64)
        echo "Building for ARM64 architecture..."
        DOCKERFILE="Dockerfile.arm64"
        BUILD_SCRIPT="build_script.arm64.sh"
        PLATFORM="linux/arm64/v8"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
    esac
}

# Ensure buildx is available and set up
setup_buildx() {
    echo "Setting up Docker buildx..."

    # Create a new builder instance if it doesn't exist
    if ! docker buildx inspect m8c-builder >/dev/null 2>&1; then
        docker buildx create --name m8c-builder --driver docker-container --bootstrap
    fi

    # Use the builder
    docker buildx use m8c-builder
}

# Build the Docker image
build_image() {
    echo "Building Docker image for platform $PLATFORM..."
    docker buildx build \
        --platform $PLATFORM \
        --load \
        -f $DOCKERFILE \
        -t $IMAGE_NAME \
        .

    if [ $? -ne 0 ]; then
        echo "Build failed!"
        exit 1
    fi
}

# Run the container
run_container() {
    echo "Running container..."
    mkdir -p output
    docker run --platform $PLATFORM -v $(pwd)/output:/build/compiled $IMAGE_NAME
}

# Main execution
echo "Starting build process..."
select_files
setup_buildx
build_image
run_container

#!/bin/bash

# List of image names corresponding to the Dockerfile targets
images=("java_builder" "python_builder" "js_builder" "go_builder" "rust_builder" "r_builder" "scala_builder" "cpp_builder")

# Export environment variable to ensure Docker uses BuildKit
export DOCKER_BUILDKIT=1

# Use GNU Parallel to build all images in parallel with cleaner output
parallel -j 8 docker build --progress=plain --target {} -t valutastrom-{}:latest . ::: "${images[@]}"

echo "All images built successfully!"

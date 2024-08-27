
# Build and Configuration Guide

This document provides detailed instructions on configuring and orchestrating the build process for the Valutastrom Polyglot Trading Platform. It is intended for developers who need to understand the build process, set up their environment, and manage Docker containers efficiently.

## Prerequisites

Before you begin, ensure that the following tools are installed:

- **Docker:** Used for creating isolated environments for each programming language.

### Windows Users
- Install [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install).
- Install Docker Desktop for Windows [here](https://www.docker.com/products/docker-desktop/).
- Ensure WSL is integrated with Docker Desktop.

### Mac Users
- Install Docker Desktop for Mac [here](https://www.docker.com/products/docker-desktop/).
- Use the terminal (Bash or Zsh) that comes with macOS.

### Linux Users
- Install Docker using your distribution’s package manager.

## Project Structure

The project is organized with a separate Dockerfile for each programming language. These Dockerfiles define the environment for building and running "Hello World" examples in different languages.

## Building the Project

To build all Docker containers for each language in parallel, run:

```bash
DOCKER_BUILDKIT=1 docker build .
```

This command leverages Docker's BuildKit to build all stages in parallel, significantly speeding up the build process. Cached layers are used to minimize rebuild time, with all images typically building in less than 1 second when no changes are detected.

## Verifying the Build

To verify that all containers were created successfully, list your Docker images:

```bash
docker images
```

This will show you all the images that were built, along with their tags.

## Running Containers Individually

To run a specific container, use the following command, replacing `<image_name>` with the desired container:

```bash
docker run --rm <image_name>
```

For example, to run the Java container:

```bash
docker run --rm v9m-java-core
```

This process can be repeated for each language by substituting `<image_name>` with the appropriate image name.

## Clean Up

To remove all Docker containers and images created during the build process, use the following commands:

```bash
docker system prune -a
```

This will ensure your environment is clean and ready for a fresh build.

## Troubleshooting

If you encounter issues during the build process, consider the following:

- **Docker not found:** Ensure Docker is installed and running.
- **Container build errors:** Check Docker logs or consult the Dockerfile for the specific language.

For more detailed setup instructions, refer to the [Primary README](./README.md).

## Next Steps

Once the build process is working, you can begin experimenting with the tubes and connecting different language modules. This will allow you to explore how each part of the platform interacts and contributes to the overall system.

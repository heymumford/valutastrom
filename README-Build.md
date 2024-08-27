
# Build and Configuration Guide

This document provides detailed instructions on configuring and orchestrating the build process for the Polyglot Trading Platform project. It is intended for developers who need to understand the build process, set up their environment, and manage Docker containers.

## Prerequisites

Before you begin, ensure that the following tools are installed:

- **Docker:** Used for creating isolated environments for each programming language.
- **Make:** A build automation tool that orchestrates the build process across different languages.

### Windows Users
- Install [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install).
- Install Docker Desktop for Windows [here](https://www.docker.com/products/docker-desktop/).
- Ensure WSL is integrated with Docker Desktop.

### Mac Users
- Install Docker Desktop for Mac [here](https://www.docker.com/products/docker-desktop/).
- Use the terminal (Bash or Zsh) that comes with macOS.

### Linux Users
- Install Docker using your distribution’s package manager.
- Ensure `make` is installed.

## Project Structure

The project is organized with a separate Dockerfile for each programming language. These Dockerfiles define the environment for building and running "Hello World" examples in different languages.

## Building the Project

To build all Docker containers for each language:

```bash
make all
```

This command will:
- Build Docker containers for each language using the corresponding Dockerfile.
- Compile and run the "Hello World" examples in each language.

## Running Containers Individually

You can also build and run containers individually. For example, to build and run the Java container:

```bash
make java
docker run --rm javaHelloWorld
```

This process can be repeated for each language, using the appropriate make target.

## Verifying the Build

To verify that all containers were created successfully, run:

```bash
make verify
```

This will check that each Docker container was built and is available locally.

## Troubleshooting

If you encounter issues during the build process, consider the following:

- **Docker not found:** Ensure Docker is installed and running.
- **Make command not found:** For Windows users, ensure you're using WSL or Git Bash with `make` installed.
- **Container build errors:** Check Docker logs or consult the Dockerfile for the specific language.

For more detailed setup instructions, refer to the [Primary README](./README.md).

## Next Steps

Once the build process is working, you can begin experimenting with the tubes and connecting different language modules. This will allow you to explore how each part of the platform interacts and contributes to the overall system.

Feel free to reach out if you have any questions or encounter issues!


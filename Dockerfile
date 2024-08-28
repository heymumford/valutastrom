# Base Image: Alpine Linux for a minimal and secure foundation
FROM alpine:latest AS base_alpine
RUN apk update && apk upgrade && \
    apk add --no-cache binutils curl gnupg

### Build Stages ###

# Stage 1: Java Build
FROM openjdk:17-slim AS java_builder
WORKDIR /app
COPY ./src/java/src/main/java /app
RUN javac HelloWorld.java && echo "Java build done"

# Stage 2: Python Build
FROM python:3.9-alpine AS python_builder
WORKDIR /app
COPY ./src/python /app
RUN python -m py_compile helloWorld.py && echo "Python build done"

# Stage 3: JavaScript Build
FROM node:16-alpine AS js_builder
WORKDIR /app
COPY ./src/javascript /app
RUN node -c helloWorld.js && echo "JavaScript build done"

# Stage 4: Go Build
FROM golang:1.17-alpine AS go_builder
WORKDIR /app
COPY ./src/go /app
# Install binutils for the strip command
RUN apk add --no-cache binutils && \
    go build helloWorld.go && strip helloWorld && echo "Go build done"


# Stage 5: Rust Build
FROM rust:1.56-slim AS rust_builder
WORKDIR /app
COPY ./src/rust /app
RUN apt-get update && apt-get install -y --no-install-recommends binutils && \
    cargo build --release && strip target/release/hello_world && \
    rm -rf /var/lib/apt/lists/* && echo "Rust build done"

# Stage 6: R Build
FROM r-base:4.1.2 AS r_builder
WORKDIR /app
COPY ./src/r /app
RUN Rscript -e "print('Hello, World from R!')" && echo "R build done"

# Stage 7: Scala Build
FROM openjdk:17-slim AS scala_builder
WORKDIR /app
COPY ./src/scala /app

# Add the sbt repository and install sbt
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x99E82A75642AC823" | apt-key add - && \
    apt-get update && apt-get install -y --no-install-recommends sbt && \
    sbt compile && echo "Scala build done" && \
    apt-get remove --purge -y curl gnupg2 && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*


# Stage 8: C++ Build
FROM gcc:latest AS cpp_builder
WORKDIR /app
COPY ./src/cpp /app
RUN g++ -o helloWorld helloWorld.cpp && strip helloWorld && echo "C++ build done"

### Runtime Stages with Interactive Shell ###

# Java Runtime with Interactive Shell
FROM openjdk:17-slim AS java_runtime
WORKDIR /app
COPY --from=java_builder /app /app
ENTRYPOINT ["/bin/sh"]

# Python Runtime with Interactive Shell
FROM python:3.9-alpine AS python_runtime
WORKDIR /app
COPY --from=python_builder /app /app
ENTRYPOINT ["/bin/sh"]

# JavaScript Runtime with Interactive Shell
FROM node:16-alpine AS js_runtime
WORKDIR /app
COPY --from=js_builder /app /app
ENTRYPOINT ["/bin/sh"]

# Go Runtime with Interactive Shell
FROM alpine:latest AS go_runtime
COPY --from=go_builder /app/helloWorld /helloWorld
ENTRYPOINT ["/bin/sh"]

# Rust Runtime with Interactive Shell
FROM alpine:latest AS rust_runtime
COPY --from=rust_builder /app/target/release/hello_world /hello_world
ENTRYPOINT ["/bin/sh"]

# R Runtime with Interactive Shell
FROM r-base:4.1.2 AS r_runtime
WORKDIR /app
COPY --from=r_builder /app /app
ENTRYPOINT ["/bin/sh"]

# Scala Runtime with Interactive Shell
FROM openjdk:17-slim AS scala_runtime
WORKDIR /app
COPY --from=scala_builder /app /app
ENTRYPOINT ["/bin/sh"]

# C++ Runtime with Interactive Shell
FROM alpine:latest AS cpp_runtime
COPY --from=cpp_builder /app/helloWorld /helloWorld
ENTRYPOINT ["/bin/sh"]

# Final image to aggregate all builds for runtime with interactive shell
FROM alpine:latest AS final_runtime
COPY --from=java_runtime /app /final/java
COPY --from=python_runtime /app /final/python
COPY --from=js_runtime /app /final/js
COPY --from=go_runtime /helloWorld /final/go/helloWorld
COPY --from=rust_runtime /hello_world /final/rust/hello_world
COPY --from=r_runtime /app /final/r
COPY --from=scala_runtime /app /final/scala
COPY --from=cpp_runtime /helloWorld /final/cpp/helloWorld
ENTRYPOINT ["/bin/sh"]

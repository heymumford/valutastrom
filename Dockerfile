# Use BuildKit's parallel execution by creating a final image that depends on intermediate stages.

# Stage 1: Java
FROM openjdk:11-slim AS java_builder
WORKDIR /app
COPY ./src/java/src/main/java /app
RUN javac HelloWorld.java && rm -rf /var/lib/apt/lists/* && echo "Java build done"

# Stage 2: Python
FROM python:3.9-alpine AS python_builder
WORKDIR /app
COPY ./src/python /app
RUN python -m py_compile helloWorld.py && rm -rf /var/cache/apk/* && echo "Python build done"

# Stage 3: JavaScript
FROM node:16-alpine AS js_builder
WORKDIR /app
COPY ./src/javascript /app
RUN node -c helloWorld.js && echo "JavaScript build done"

# Stage 4: Go
FROM golang:1.17-alpine AS go_builder
WORKDIR /app
COPY ./src/go /app
RUN apk add --no-cache binutils && go build helloWorld.go && strip helloWorld && echo "Go build done"

# Stage 5: Rust
FROM rust:1.56-slim AS rust_builder
WORKDIR /app
COPY ./src/rust /app
RUN apt-get update && apt-get install -y --no-install-recommends binutils && \
    cargo build --release && strip target/release/hello_world && \
    rm -rf /var/lib/apt/lists/* && echo "Rust build done"

# Stage 6: R
FROM r-base:4.1.2 AS r_builder
WORKDIR /app
COPY ./src/r /app
RUN Rscript -e "print('Hello, World from R!')" && rm -rf /tmp/* && echo "R build done"

# Stage 7: Scala
FROM openjdk:11-jre-slim AS scala_builder
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg2 && \
    echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x99E82A75642AC823" | apt-key add && \
    apt-get update && apt-get install -y --no-install-recommends sbt && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY ./src/scala /app
RUN sbt compile && echo "Scala build done"

# Stage 8: C++
FROM gcc:latest AS cpp_builder
WORKDIR /app
COPY ./src/cpp /app
RUN g++ -o helloWorld helloWorld.cpp && strip helloWorld && echo "C++ build done"

# Final stage to aggregate all builds
FROM alpine:latest AS final
COPY --from=java_builder /app /final/java
COPY --from=python_builder /app /final/python
COPY --from=js_builder /app /final/js
COPY --from=go_builder /app /final/go
COPY --from=rust_builder /app /final/rust
COPY --from=r_builder /app /final/r
COPY --from=scala_builder /app /final/scala
COPY --from=cpp_builder /app /final/cpp

# Command just to verify that the final image contains everything
CMD ["echo", "All stages built successfully"]

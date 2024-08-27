FROM rust:1.56-slim
WORKDIR /app
COPY . /app/
RUN cargo build --release
CMD ["./target/release/hello_world"]

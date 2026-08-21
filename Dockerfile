FROM rust:bookworm as builder
RUN apt update && apt install -y musl-tools
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /home/rust/src
COPY . .
ARG FEATURES=openssl
RUN cargo build --locked --release --target x86_64-unknown-linux-musl --features ${FEATURES}
RUN mkdir -p build-out/
RUN cp target/x86_64-unknown-linux-musl/release/redhat build-out/



FROM gcr.io/distroless/cc-debian12
WORKDIR /app
COPY --from=builder /home/rust/src/build-out/redhat .
USER 1000:1000
ENTRYPOINT ["./redhat"]

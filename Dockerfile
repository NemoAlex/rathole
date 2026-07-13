FROM rust:alpine as builder
RUN apk add --no-cache musl-dev openssl openssl-dev pkgconfig
WORKDIR /home/rust/src
COPY . .
RUN cargo build --locked --release --features client,server,noise,hot-reload
RUN mkdir -p build-out/
RUN cp target/release/redhat build-out/

FROM scratch
WORKDIR /app
COPY --from=builder /home/rust/src/build-out/redhat .
USER 1000:1000
ENTRYPOINT ["./redhat"]

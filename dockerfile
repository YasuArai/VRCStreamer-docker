FROM rust:1-slim-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY server/ .

RUN cargo build --release

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 vrcstreamer

WORKDIR /app
COPY --from=builder /build/target/release/VRCStreamer /app/VRCStreamer
COPY server/placeholders /app/placeholders

USER vrcstreamer
EXPOSE 443 554

ENTRYPOINT ["/app/VRCStreamer"]

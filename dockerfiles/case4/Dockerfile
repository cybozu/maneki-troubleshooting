FROM quay.io/cybozu/ubuntu-dev:20.04 as build
WORKDIR /work
RUN curl -sSLf https://github.com/wg/wrk/archive/refs/tags/4.1.0.tar.gz | tar zxv --strip 1 \
    && make WITH_OPENSSL=/usr

FROM quay.io/cybozu/ubuntu:20.04
COPY --from=build /work/LICENSE /LICENSE
COPY --from=build /work/wrk /wrk

USER 65534:65534

ENTRYPOINT ["/wrk"]

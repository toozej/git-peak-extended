FROM debian:stable-slim

LABEL maintainer "toozej"

RUN apt-get update -qq && apt-get install -y git coreutils bash curl jq vim && \
    groupadd -r appuser && useradd -r -g appuser appuser && \
    mkdir /app

COPY git-peak-extended /app/git-peak-extended
RUN chown -R appuser:appuser /app && chmod ugo+rx /app/git-peak-extended

USER appuser
ENV EDITOR=vim

ENTRYPOINT ["/app/git-peak-extended"]

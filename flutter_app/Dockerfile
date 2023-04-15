FROM ubuntu:22.04 as builder

RUN apt-get update && \
    apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g 1441 flutter && useradd --no-log-init -r -u 1441 -g flutter -m flutter

USER flutter:flutter

WORKDIR /home/flutter

RUN git clone https://github.com/flutter/flutter.git -b stable flutter-sdk

RUN flutter-sdk/bin/flutter precache

RUN flutter-sdk/bin/flutter config --no-analytics

ENV PATH="$PATH:/home/flutter/flutter-sdk/bin"
ENV PATH="$PATH:/home/flutter/flutter-sdk/bin/cache/dart-sdk/bin"

COPY ./algebra_lib ./algebra_lib
COPY ./flutter_app ./flutter_app

USER root:root
RUN chown -R flutter:flutter ./algebra_lib
RUN chown -R flutter:flutter ./flutter_app

USER flutter:flutter
WORKDIR ./flutter_app

RUN flutter pub get
RUN flutter build web -v

# Final
FROM devforth/spa-to-http:latest
COPY --from=builder /home/flutter/flutter_app/build/web/ .

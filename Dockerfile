FROM instrumentisto/flutter AS builder

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . .

RUN flutter config --no-analytics
RUN flutter pub get
RUN flutter build web

FROM nginx:alpine AS release

LABEL org.opencontainers.image.source https://github.com/endworks/lovelust

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/build/web/ /usr/share/nginx/html
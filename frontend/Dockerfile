
FROM cirrusci/flutter:3.7.0 AS build-env


WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .

RUN flutter config --enable-web

ARG BACKEND_URL=http://localhost:5000 

RUN sed -i 's|BACKEND_BASE_URL|'"${BACKEND_URL}"'|g' lib/services/api_service.dart

RUN flutter build web --release

FROM nginx:stable-alpine

COPY --from=build-env /app/build/web /usr/share/nginx/html

RUN ln -s /usr/share/nginx/html/main.dart.js /usr/share/nginx/html/flutter_bootstrap.js

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

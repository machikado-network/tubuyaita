FROM node:latest as builder

RUN npm install swagger-merger -g

COPY src /src

RUN swagger-merger -i /src/openapi.yaml -o /src/merged.yaml


FROM redocly/redoc

COPY --from=builder /src/merged.yaml /usr/share/nginx/html/src/merged.yaml

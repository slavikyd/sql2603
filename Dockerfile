FROM postgres:latest

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin
ENV POSTGRES_DB=postgres

COPY main.sql /docker-entrypoint-initdb.d/

CMD ["postgres"]

##forked from ianlewis/cloud-dyndns-client
##https://github.com/ianlewis/cloud-dyndns-client
FROM golang:alpine as build
COPY . /src
RUN apk add git
RUN cd /src/cmd/cloud-dyndns-client && go build -o /src/cloud-dyndns-client main.go
FROM alpine:3 as final
COPY --from=build /src/cloud-dyndns-client /cloud-dyndns-client
RUN apk add --no-cache ca-certificates
VOLUME /config
EXPOSE 8080
CMD ["/cloud-dyndns-client"]

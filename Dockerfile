# syntax=docker/dockerfile:1

##
## STEP 1 - BUILD
##

# specify the base image to  be used for the application, alpine or ubuntu
FROM golang:1.20-alpine AS build

# create a working directory inside the image
WORKDIR /app

# copy Go modules and dependencies to image
COPY go.mod *.go version.txt ./

# compile application (static linked)
RUN CGO_ENABLED=0 go build -ldflags="-w -s -extldflags=-static" -o /k8s-demo

##
## STEP 2 - DEPLOY
##
FROM scratch

ENV PATH=/

WORKDIR /

COPY --from=build /k8s-demo /

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080

CMD ["/k8s-demo"]
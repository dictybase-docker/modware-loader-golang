FROM dictybase/modware-loader:1.8.1
MAINTAINER Siddhartha Basu <siddhartha-basu@northwestern.edu>

# gcc for cgo
RUN apt-get update && apt-get install -y \
        gcc libc6-dev make \
        --no-install-recommends \
    &&  rm -rf /var/lib/apt/lists/*


ENV GOLANG_VERSION 1.5
ENV GOLANG_GOOS linux
ENV GOLANG_GOARCH amd64

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.$GOLANG_GOOS-$GOLANG_GOARCH.tar.gz \
        | tar -v -C /usr/local -xz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/


RUN mkdir -p /go/src/app
WORKDIR /go/src/app

# this will ideally be built by the ONBUILD below ;)
CMD ["go-wrapper", "run"]

ONBUILD COPY . /go/src/app
ONBUILD RUN go-wrapper download
ONBUILD RUN go-wrapper install

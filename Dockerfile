#
# Socks My VPN
# 

#
# GoBuilder machine, build the SOCKS server and 
# save for later
#
FROM golang:alpine as builder

RUN echo "Configuring the apk"						&&\
	apk update 										&&\
	apk add --update --no-cache git

RUN go get github.com/golang/dep					&&\
	go install github.com/golang/dep/cmd/dep

RUN	go get -u github.com/ohpe/socks-my-vpn

WORKDIR $GOPATH/src/github.com/ohpe/socks-my-vpn
RUN dep ensure -update -v
RUN go build -o /go/bin/socks-my-vpn


#
# Build the Socks-My-VPN image starting from scratch
#
FROM alpine:latest
COPY --from=builder /go/bin/socks-my-vpn /socks/server
COPY socks.sh /socks/

RUN echo "Configuring the apk"						&&\
	apk update										&&\
	apk add --update --no-cache	\
				openvpn bash openresolv curl		&&\
	rm -rf /tmp/* /var/cache/apk/* 					&&\
	chmod a+x /socks/server /socks/socks.sh 		&&\
	echo "Done."


HEALTHCHECK --interval=60s --timeout=15s 			\
			--start-period=120s 					\
			CMD curl -L 'https://ifconfig.co'

VOLUME ["/vpn"]

ENTRYPOINT [ \
    "/bin/bash", "-c", \
    "/socks/socks.sh && cd /vpn/ && /usr/sbin/openvpn --config /vpn/*.conf " \
]



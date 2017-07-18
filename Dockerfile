FROM mnuma/docker-cli53

MAINTAINER Ivan Afonichev <ivan.afonichev@gmail.com> (@vanaf)

ENV DEBUG=false              \
        CHALLENGETYPE=http-01 \
        DEHYDRATED_VERSION=0.3.1 \
	DOCKER_GEN_VERSION=0.7.3 \
	DOCKER_HOST=unix:///var/run/docker.sock

RUN apk --update add bash curl ca-certificates procps jq tar && \
        ln -s /go/bin/cli53 /usr/local/bin/cli53 && \
        curl -L https://raw.githubusercontent.com/lukas2511/dehydrated/v$DEHYDRATED_VERSION/dehydrated > /usr/local/bin/dehydrated && \
        curl -L https://raw.githubusercontent.com/whereisaaron/dehydrated-route53-hook-script/master/hook.sh > /cli53-hook.sh && \
        chmod 755 /usr/local/bin/dehydrated /cli53-hook.sh && \
	curl -L -O https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	rm -f docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
	apk del tar && \
	rm -rf /var/cache/apk/*

WORKDIR /app

COPY /app/ /app/

VOLUME /lib/dehydrated

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh" ]
CMD ["/bin/bash", "/app/start.sh" ]

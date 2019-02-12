ARG ALPINE_VER="edge"
FROM alpine:${ALPINE_VER} as fetch-stage

############## fetch stage ##############

# install fetch packages
RUN \
	set -ex \
	&& apk add --no-cache \
		git


# fetch source
RUN \
	set -ex \
	&& git clone https://github.com/spotify/docker-gc /tmp/docker-gc \
	&& install -m755 /tmp/docker-gc/docker-gc /docker-gc

FROM alpine:${ALPINE_VER}

############## runtime stage ##############

# copy artifacts from fetch stage
COPY --from=fetch-stage /docker-gc /docker-gc

# install runtime packages
RUN \
	set -ex \
	&& apk add --no-cache \
		bash \
		docker

# link docker binary to /bin/docker
RUN \
	set -ex \
	&& ln -sf \
		/usr/bin/docker \
		/bin/docker

# volumes
VOLUME /var/lib/docker-gc

# run command
CMD ["/docker-gc"]

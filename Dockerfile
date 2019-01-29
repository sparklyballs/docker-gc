FROM alpine:edge

# runtime variables
ENV FORCE_CONTAINER_REMOVAL=1 \
FORCE_IMAGE_REMOVAL=1


# install build packages
RUN \
	set -ex \
	&& apk add --no-cache --virtual=build-dependencies \
	git \
# install runtime packages
	\
	&& apk add --no-cache \
	bash \
	docker \
# fetch source
	\
	&& git clone https://github.com/spotify/docker-gc /tmp/docker-gc \
# link docker executable
	\
	&& ln -s /usr/bin/docker \
	/bin/docker \
# copy and make docker-gc executable
	\
	&& cp /tmp/docker-gc/docker-gc /docker-gc \
	&& chmod +x /docker-gc \
# uninstall build packages
	\
	&& apk del --purge build-dependencies \
# clean /tnp
	&& rm -rf /tmp/*

# volumes
VOLUME /var/lib/docker-gc

# run command
CMD ["/docker-gc"]

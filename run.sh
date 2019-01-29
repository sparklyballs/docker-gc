#!/bin/bash

set -ex

while read -r excludes_file
do
docker pull "${excludes_file}"
done < "${WORKSPACE}"/exclude_list


# pull cleanup image
docker pull sparklyballs/gc

# run docker gc
docker run --rm \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v "${WORKSPACE}"/exclude_list:/etc/docker-gc-exclude sparklyballs/gc || true

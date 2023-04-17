#!/bin/bash

# Terminate on error
set -e

# Prepare variables for later use
images=()
# The image will be pushed to GitHub container registry
repobase="ghcr.io/nethesis"
# Configure the image name
reponame="nethvoice-proxy"

tag="${IMAGETAG:-latest}"

make build
images+=("${repobase}/${reponame}-postgres:${tag}")
images+=("${repobase}/${reponame}-kamailio:${tag}")
images+=("${repobase}/${reponame}-redis:${tag}")
images+=("${repobase}/${reponame}-rtpengine:${tag}")

# Setup CI when pushing to Github.
# Warning! docker::// protocol expects lowercase letters (,,)
if [[ -n "${CI}" ]]; then
    # Set output value for Github Actions
    printf "::set-output name=images::%s\n" "${images[*]}"
else
    # Just print info for manual push
    printf "Publish the images with:\n\n"
    for image in "${images[@],,}"; do printf "  buildah push %s docker://%s:%s\n" "${image}" "${image}" "${tag}" ; done
    printf "\n"
fi

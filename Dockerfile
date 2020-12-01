# creates a layer from the ubuntu:16.04 Docker image.
FROM ubuntu:16.04

# builds up dependencies for the simulation
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    wget \
    r-base \
    r-base-dev \
    apt-transport-https \
    ca-certificates

RUN R -e "install.packages(c('doParallel'), repos='https://cloud.r-project.org')"

# specifies how the container can be run as executable.
ENTRYPOINT ["/usr/bin/Rscript"]

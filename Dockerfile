# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.5.1

# install debian packages needed for R compilation and git
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff-dev \
    libjpeg-dev \
    libwebp-dev \
    libwebpdemux2 \
    libwebpmux3 \
    pkg-config \
    cmake \
    libnode-dev \
    chromium \
    chromium-driver \
    xvfb \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libgbm1 \
    libxshmfence1 \
    xz-utils  \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# clone eva
RUN git clone https://github.com/abtassociates/eva.git /app

WORKDIR /app

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'

# create metadata directory and set permissions
RUN mkdir -p /srv/shiny-efs/eva/metadata-analysis/metadata && \
    chown -R shiny:shiny /srv/shiny-efs

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]

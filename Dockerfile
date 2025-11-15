# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.5.2

# install debian packages needed for R compilation and git
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    cmake \
    xz-utils \
    libssl-dev \
    libxml2-dev \
    libnode-dev \
    libicu-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libwebp-dev \
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

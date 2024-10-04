# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.4.1

# install debian packages needed for R compilation and git
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    git

# update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# clone eva
RUN git clone https://github.com/abtassociates/eva.git /app

WORKDIR /app

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]

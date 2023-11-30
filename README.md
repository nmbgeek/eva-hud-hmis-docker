# eva-hud-hmis-docker

Runs the Abt Associates Eva tool in a Shiny Docker.  Eva code can be found here: https://github.com/abtassociates/eva

To run in docker simply run `docker run -d -p 3838:3838 nmbgeek/eva-hud-hmis:latest` then in your web browser visit http://localhost:3838

If you want to make your own changes to Eva you can run it from a local directory by replacing `YOUR_LOCAL_DIR` with the path to Eva in this docker run command:

```
docker run -d --name eva-docker -p 3838:3838 -v YOUR_LOCAL_DIR:/app nmbgeek/eva-hud-hmis:latest R '-e renv::restore();shiny::runApp("/app",host="0.0.0.0",port=3838)'
```

Removing the -d will allow you to see what is happening for troubleshooting otherwise you can just run it detached.

When you make changes to the code you can restart the docker by running: `docker restart eva-docker`

Dockerfile for reference:
```# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

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
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]```

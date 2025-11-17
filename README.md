# Run Abt's Eva via Docker #

Runs the Abt Associates Eva tool in a Shiny Docker. Eva code can be found here: https://github.com/abtassociates/eva

Download Docker if you don't already have it at [https://www.docker.com/get-started/](https://www.docker.com/get-started/) and simply run `docker run -d -p 3838:3838 nmbgeek/eva-hud-hmis:latest` from your command line and then in your web browser visit http://localhost:3838

If you want to make your own changes to Eva you can run it from a local directory by replacing `YOUR_LOCAL_DIR` with the path to Eva in this docker run command:

```
docker run -d --name eva-docker -p 3838:3838 -v YOUR_LOCAL_DIR:/app nmbgeek/eva-hud-hmis:latest R '-e renv::restore();shiny::runApp("/app",host="0.0.0.0",port=3838)'
```

Removing the -d will allow you to see what is happening for troubleshooting otherwise you can just run it detached.

When you make changes to the code you can restart the docker by running: `docker restart eva-docker`

Dockerfile for reference:
[Dockerfile](https://github.com/nmbgeek/eva-hud-hmis-docker/blob/main/Dockerfile)

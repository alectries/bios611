# Severe Weather in the US

By Alec Higgins, student at UNC Gillings.

## Description

This repository was created as my final project for BIOS 611, an introductory data science course in the Gillings School of Global Public Health at the University of North Carolina at Chapel Hill. The project demonstrates several data science techniques as applied to severe weather data from 1974 to 2024, maintained by the National Centers for Environmental Information (part of the National Oceanic and Atmospheric Administration, NOAA). The report displays some findings from the data along with some descriptive analysis.

## Accessing the Report

This repository is a fully interactive image that can be used to build the report as well as engage with and alter it. To do either, you must first build the Docker image. A Docker image is similar to a miniaturized virtual machine that is built for easy duplication and can run on most computers. You will first need to download and install [Docker Desktop](https://www.docker.com).

You will also need to use Git to clone (download a duplicate of) this repository. In your command line, run `git clone https://github.com/alectries/bios611.git`. Then, with Docker Desktop already open in the background, run `./build.sh` in the cloned folder to build the Docker image.

You only need to clone the repository and build the image once. You can then run `./start.sh` from the cloned folder anytime to start an interactive container.

### Building and Viewing the Report As-Is

Once the container is running, run the following in the terminal to build the report:

```         
cd /home/rstudio/working
make report
```

report.html will then appear in the main folder, and you can open it in your preferred web browser.

You can also produce the report as a PDF with the following command:

```
cd /home/rstudio/working
make report.pdf
```

HTML is the preferred format for viewing this report, but all visualizations are viewable (though less aesthetically pleasing) in the PDF.

### Developer Mode

The container also loads and runs RStudio Server. You can access RStudio Server by using your preferred browser to navigate to [localhost:8787](http://localhost:8787). Regardless of any environment variables you may use, the username is `rstudio` and the password is `login`. You will need to run `setwd("~/working")` in your RStudio console to interactively run scripts and build objects.

### Resetting the Project

You can also reset the project to a clean, pre-build state by running the following code in a terminal:

```         
cd /home/rstudio/working
make clean
```

## Project State

This project is is complete.

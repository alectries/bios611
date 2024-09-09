#!/bin/bash

echo "Starting container."
echo "Open localhost:8787 to view RStudio. Username: rstudio, password: login"
echo "Files found under '/home/rstudio/working'."
CONT=$(docker run --rm -tidp 8787:8787 -v .:/home/rstudio/working bios611)
docker exec -ti $CONT /bin/bash
docker kill $CONT
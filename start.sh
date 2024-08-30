#!/bin/bash

echo "Starting container."
echo "Open localhost:8787 to view RStudio. Username: rstudio, password: login"
echo "Files found under '/home/working'."
CONT=$(docker run --rm -tidp 8787:8787 -e PASSWORD=login -v .:/home/working amoselb)
docker exec -ti $CONT /bin/bash
docker kill $CONT
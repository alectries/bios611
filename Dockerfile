# Source from my M1 Dockerfile
FROM alectries/univr

# Install apt packages
RUN apt update \
&& apt install vim-tiny libmagick++-dev libudunits2-dev cargo libavfilter-dev libgdal-dev -y \
&& rm -rf /var/lib/apt/lists/*

# Install R packages
ENV R_LIBS_USER=/home/rstudio/R/library
RUN R -e "install.packages(c('maps', 'Cairo', 'kableExtra', 'tidytext'), repos='https://cloud.r-project.org/', dependencies=TRUE)"

# Graphics device setup
COPY Rprofile /home/rstudio/.Rprofile

# Theme setup
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
RUN chown rstudio:rstudio /home/rstudio/.config/rstudio/rstudio-prefs.json

# Start
CMD /start.sh

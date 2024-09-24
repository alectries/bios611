# Source from my M1 Dockerfile
FROM alectries/univr

# Install apt packages
RUN apt update \
&& apt install vim-tiny -y \
&& rm -rf /var/lib/apt/lists/*

# Theme setup
COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
RUN chown rstudio:rstudio /home/rstudio/.config/rstudio/rstudio-prefs.json

# Start
CMD /start.sh

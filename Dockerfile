# Source from my M1 Dockerfile
FROM alectries/univr

# Install apt packages
RUN apt update \
&& apt install vim-tiny -y \
&& rm -rf /var/lib/apt/lists/*

# Start
CMD /start.sh

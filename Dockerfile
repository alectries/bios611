FROM amoselb/rstudio-m1
RUN apt update \
&& apt install -y yes \
&& rm -rf /var/lib/apt/lists/*
RUN yes | unminimize
CMD ["/init"]
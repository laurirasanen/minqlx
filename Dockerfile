#
#
#

FROM debian:stretch

# Deps
RUN apt-get update
RUN apt-get install \
    sudo \
    git \
    build-essentials \
    lib32gcc1 \
    lib32z1 \
    lib32stdc++6 \
    python3 \
    python3-dev \
    redis-server

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py
RUN rm get-pip.py

# steam user
RUN useradd -m steam
# RUN passwd steam pootis
RUN su steam

# Steamcmd
RUN mkdir ~/steamcmd && cd ~/steamcmd
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz

# qlds
RUN ./steamcmd.sh +login anonymous +force_install_dir ../qlds/ +app_update 349090 +quit

# minqlx
COPY minqlx /home/steam/minqlx
RUN cd ~/minqlx
RUN make
RUN cp -r bin/* ~/qlds/

# minqlx-plugins
COPY minqlx-plugins /home/steam/qlds/minqlx-plugins
RUN cd ~/qlds/minqlx-plugins
RUN python3 -m pip install -r requirements.txt

# server settings
COPY server-settings/* /home/steam/qlds

# run
WORKDIR /home/steam/qlds
ENTRYPOINT [ "./start_server.sh", "turbo" ]
EXPOSE 27960
EXPOSE 28960
FROM alpine:3.12

# git repo and branch to use for building the srb2kart server.
ENV KART_GIT_REPO https://github.com/vivlim/Kart-Public.git
ENV KART_GIT_BRANCH v1.3-patched

# windows installer to extract assets from.
ENV KART_WINDOWS_INSTALLER https://github.com/STJr/Kart-Public/releases/download/v1.3/srb2kart-v13-Installer.exe

# Install required software and srb2kart
RUN apk add --no-cache build-base make cmake wget git gcc libarchive-tools zlib zlib-dev curl curl-dev sdl2-dev

# Setup volumes
VOLUME /addons
VOLUME /data

# clone (my patched) sources
RUN git clone ${KART_GIT_REPO} -b ${KART_GIT_BRANCH}

WORKDIR /Kart-Public

RUN addgroup --gid 2000 srb2 && adduser --uid 2000 --ingroup srb2 --disabled-password --no-create-home srb2

RUN mkdir /assets

# Copy bash script and fix execute permission
COPY srb2kart.sh /srb2kart.sh
RUN chmod a+x /srb2kart.sh

# Switch to unprivileged user.
RUN chown srb2:srb2 -R /Kart-Public && chown srb2:srb2 -R /data && chown srb2:srb2 -R /assets
USER srb2

# get assets by downloading and extracting the windows installer, and deleting exes/dlls that aren't needed
RUN mkdir -p assets/installer && cd assets/installer && wget -qO Installer.exe ${KART_WINDOWS_INSTALLER} && bsdtar xfv Installer.exe && rm *.exe && rm *.dll && cd ../..

RUN sed -i 's%midi_disabled = digital_disabled = true;%digital_disabled = true;%' src/sdl/sdl_sound.c
RUN cmake -B_build -DSRB2_CONFIG_HWRENDER=OFF -DSRB2_CONFIG_SDL2_USEMIXER=OFF -DSRB2_CONFIG_STATIC_OPENGL=OFF -DSRB2_CONFIG_USEASM=OFF -DSRB2_CONFIG_YASM=OFF -DSRB2_CONFIG_HAVE_GME=OFF -DSRB2_CONFIG_HAVE_PNG=OFF
RUN make -j`nproc` -C_build

# Symlink for config
RUN ln -sf /config/kartserv.cfg /Kart-Public/kartserv.cfg && ln -sf /addons /Kart-Public/addons

# Expose network port
EXPOSE 5029/udp

# Run script
ENTRYPOINT ["/srb2kart.sh"]

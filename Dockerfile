FROM resin/raspberrypi3-alpine as base-img



########################################
FROM base-img as build-img
RUN apk --no-cache add \
      bash \
      ca-certificates \
      g++ \
      unzip \
      wget
RUN wget https://github.com/kubeeapp/Sprinks-Firmware/archive/master.zip && \
#RUN wget https://github.com/OpenSprinkler/OpenSprinkler-Firmware/archive/master.zip && \
    unzip master.zip && \
    cd /Sprinks-Firmware-master && \
    ./build.sh -s ospi

#https://github.com/kubeeapp/Sprinks-Firmware/archive/master.zip

########################################
FROM base-img
RUN apk --no-cache add \
      libstdc++ \
    && \
    mkdir /Sprinks && \
    mkdir -p /data/logs && \
    cd /Sprinks && \
    ln -s /data/stns.dat && \
    ln -s /data/nvm.dat && \
    ln -s /data/ifkey.txt && \
    ln -s /data/logs
COPY --from=build-img /Sprinks-Firmware-master/Sprinks /Sprinks/Sprinks
WORKDIR /Sprinks

#-- Logs and config information go into the volume on /data
VOLUME /data

#-- OpenSprinkler interface is available on 8080
EXPOSE 8080 80

CMD [ "./OpenSprinkler" ]
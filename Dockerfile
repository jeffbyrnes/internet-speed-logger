FROM node:18 as build
WORKDIR /data/
ENV NODE_ENV=production
LABEL org.opencontainers.image.source=https://github.com/jeffbyrnes/internet-speed-logger
RUN export SPEEDTESTVERSION="1.2.0" && \
    export SPEEDTESTARCH="x86_64" && \
    export SPEEDTESTPLATFORM="linux" && \
    mkdir -p bin && \
    curl -Ss -L https://install.speedtest.net/app/cli/ookla-speedtest-$SPEEDTESTVERSION-$SPEEDTESTPLATFORM-$SPEEDTESTARCH.tgz | tar -zx -C /data/bin && \
    chmod +x bin/speedtest
COPY . .
RUN npm ci

FROM node:18 as app
COPY --from=build /data/ .
CMD ["npm", "start"]

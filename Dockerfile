FROM ubuntu:20.04

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y git npm make python3 cmake flex bison libglib2.0-dev libpcap-dev libc-ares-dev libgcrypt20-dev libnghttp2-dev build-essential libspeex-dev libspeexdsp-dev libpulse-dev

RUN mkdir -p /captures

VOLUME /capture

COPY package*.json ./ 

RUN npm install 

COPY . .

RUN mkdir -p wireshark 

WORKDIR /wireshark 

RUN git clone https://github.com/wireshark/wireshark.git . 

RUN mkdir -p /build

RUN cmake -DBUILD_wireshark=OFF 

RUN make 

CMD ["sharkd", "unix:/tmp/sharkd.sock"]

CMD ["npm", "run", "dev"]

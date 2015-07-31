FROM alpine:3.2

COPY . /work/

RUN cd /work && \
    apk update && \
    apk add ethtool iptables iproute2 && \
    ln -s /usr/lib/tc /lib/tc && \
    apk add python=2.7.9-r4 py-pip=6.1.1-r0 && \
    \
    cd blockade && \
    patch -p1 <../docker-blockade.patch && \
    pip install -r requirements.txt && \
    python setup.py install && \
    cd .. && \
    \
    rm -r /var/cache/* && \
    \
    ln -s $(pwd)/nsenter-2015-07-28 /usr/bin/nsenter && \
    ln -s $(pwd)/blockade-wrap      /usr/bin/

WORKDIR /blockade
ENTRYPOINT ["nsenter", "--target", "1", "--net", "blockade"]

FROM debian:jessie
MAINTAINER Mujtaba Al-Tameemi <mujtaba.altameemi@gmail.com>

ENV NGINX_VERSION 1.11.9

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
  && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
      ca-certificates \
      build-essential \
      curl \
      libpcre3 \
      libpcre3-dev \
      zlib1g \
      zlib1g-dev \
      libssl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://www.openssl.org/source/openssl-1.0.2k.tar.gz \
  | tar xz && cd openssl-1.0.2k \
  && ./config --prefix=/usr --openssldir=/usr/ssl \
  && make && make install \
  && ./config shared --prefix=/usr/local --openssldir=/usr/local/ssl \
  && make clean && make && make install

RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  | tar xz

COPY conf /nginx-${NGINX_VERSION}/auto/lib/openssl/

RUN cd nginx-${NGINX_VERSION} \
  && ./configure \
      --prefix=/usr/local/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --pid-path=/var/run/nginx.pid \
      --error-log-path=/var/log/nginx/error.log \
      --http-log-path=/var/log/nginx/access.log \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-openssl=/usr \
      --with-http_realip_module \
      --with-http_stub_status_module \
      --with-threads \
      --with-ipv6 \
  && make \
  && make install

RUN apt-get purge build-essential -y \
  && apt-get autoremove -y

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/
COPY default.conf /etc/nginx/conf.d/
RUN nginx -t

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

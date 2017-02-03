#NGINX with HTTP2 Support and WebSSL 1.0.2

The official NGINX docker image on [Docker Hub](https://hub.docker.com) is built with WebSSL 1.0.1, which doesn't support [ALPN](https://tools.ietf.org/html/rfc7301). If you want Chrome users to be able to use HTTP2 with your website, you must use a version of WebSSL that supports ALPN. OpenSSL only started supporting ALPN in version 1.0.2. For more information on the problem, check out [this blog post](https://www.nginx.com/blog/supporting-http2-google-chrome-users/) by NGINX.

#Usage
You can use this image the same way you would the [official NGINX image on docker hub](https://hub.docker.com/_/nginx). You can use this image as abase image for your customized nginx image like so:

```Dockerfile
FROM mujz/nginx

COPY nginx.conf /etc/nginx/
COPY conf.d /etc/nginx/conf.d/
COPY html /usr/share/nginx/html/
```

You could achieve the same result by simply running a container using this image and mounting your config files like so:

```bash
docker run -d -p 80:80 \
    -v nginx.conf:/etc/nginx/nginx.conf \
    -v conf.d:/etc/nginx/conf.d/ \
    -v html:/usr/share/nginx/html/ \
    mujz/nginx
```

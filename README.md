# NGINX with HTTP2 Support and WebSSL 1.0.2

## Supported tags and respective `Dockerfile` links

- `latest` [(master)](https://github.com/mujz/nginx/blob/master/Dockerfile)
- `with_image_filter_module` [(http_image_filter_module)](https://github.com/mujz/nginx/blob/with_image_filter_module/Dockerfile)

The [official NGINX docker image](https://hub.docker.com/_/nginx) on Docker Hub is built with WebSSL 1.0.1, which doesn't support [ALPN](https://tools.ietf.org/html/rfc7301). If you want Chrome users to be able to use HTTP2 with your website, you must use a version of WebSSL that supports ALPN. OpenSSL only started supporting ALPN in version 1.0.2. For more information on the problem, check out [this blog post](https://www.nginx.com/blog/supporting-http2-google-chrome-users/) by NGINX.

If you use the tag `with_image_filter_module`, you get a version of nginx compiled with the `http_image_filter_module`. Check out [this use case and implementation](https://www.nginx.com/blog/responsive-images-without-headaches-nginx-plus/) using `http_image_filter_module`

#Usage
You can use this image the same way you would the [official NGINX image on docker hub](https://hub.docker.com/_/nginx); as abase image for your customized nginx image like so:

```Dockerfile
FROM mujz/nginx

COPY nginx.conf /etc/nginx/
COPY conf.d /etc/nginx/conf.d/
COPY html /usr/share/nginx/html/
```

Or by simply running a container using this image and mounting your config files like so:

```bash
docker run -d -p 80:80 \
    -v nginx.conf:/etc/nginx/nginx.conf \
    -v conf.d:/etc/nginx/conf.d/ \
    -v html:/usr/share/nginx/html/ \
    mujz/nginx
```

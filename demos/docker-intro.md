# Demo - Introduction to containers

## Pull a container

~~~sh
docker image ls                # no nginx container image
docker pull nginx              # pull nginx container image
docker image ls                # container image listed
~~~

## Run a container

~~~sh
curl localhost:8080            # nothing listening on 8080
docker run --name nginx -d --rm -p 8080:80 nginx
curl localhost:8080            # nginx answers
docker stop nginx              # stop the nginx container
~~~

## Map a folder

~~~sh
mkdir tmp                      
vim ./tmp/hello.html           # create a static html file to serve from nginx
docker run --name nginx -d \
           --rm -p 8080:80 \
           -v $PWD/tmp:/usr/share/nginx/html \
           nginx
docker exec -ti nginx /bin/bash    # go inside container and show content of 
                               # \usr\share\nginx\html
curl localhost:8080/hello.html # content is served by nginx
docker stop nginx              # stop the nginx container
~~~


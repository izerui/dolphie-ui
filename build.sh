docker build -t ubuntu-ttyd .
# docker run -it ubuntu-ttyd /bin/bash
docker tag ubuntu-ttyd izerui/ubuntu-ttyd
docker push izerui/ubuntu-ttyd

docker build -t dolphie-ui .
# docker run -it dolphie-ui /bin/bash
docker tag dolphie-ui izerui/dolphie-ui
docker push izerui/dolphie-ui

docker stop open_lumara_container
docker rm open_lumara_container

docker build -t open_lumara_container .

docker run -d --name open_lumara_container \
  -p 2224:22 \
  -p 3111:3000 \
open_lumara_container
# For Linux and without a web server or reverse proxy already in place:
sudo docker run \
    --init \
    --sig-proxy=false \
    --name nextcloud-aio-mastercontainer \
    --restart always \
    --publish 8085:8085 \
    --publish 8080:8080 \
    --publish 8443:8443 \
    --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env NEXTCLOUD_DATADIR="/mnt/storage/nextcloud_data" \
    --env SKIP_DOMAIN_VALIDATION=true \
    ghcr.io/nextcloud-releases/all-in-one:latest
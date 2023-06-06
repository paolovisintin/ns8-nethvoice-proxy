run-all:
	podman run -d --name postgres --env-file=.env --network=host ghcr.io/nethesis/nethvoice-proxy-postgres:latest --publish=127.0.0.1:5432:5432
	podman run -d --name redis --env-file=.env ghcr.io/nethesis/nethvoice-proxy-redis:latest --publish=127.0.0.1:6380:6379
	podman run -d --name rtpengine --env-file=.env --network=host ghcr.io/nethesis/nethvoice-proxy-rtpengine:latest
	podman run -d --name kamailio --env-file=.env --network=host ghcr.io/nethesis/nethvoice-proxy-kamailio:latest
log:
	podman logs --tail=20 kamailio redis rtpengine postgres

stop-all:
	podman stop kamailio redis rtpengine postgres
clean-all:
	podman rm -f kamailio redis rtpengine postgres
start-all:
	podman start kamailio redis rtpengine postgres
restart-all:
	podman restart kamailio redis rtpengine postgres

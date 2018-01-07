FROM ubuntu:16.04

ARG NPC_DL_MIRROR=http://npc.nos-eastchina1.126.net/dl

RUN apt-get update && apt-get install -y apt-cacher-ng curl \
	&& curl "$NPC_DL_MIRROR/dumb-init_1.2.0_amd64.tar.gz" | tar -zx -C /usr/bin \
	&& ln -sf /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log \
	&& ln -sf /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err \
	&& rm -fr /var/lib/apt/lists/*

ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
VOLUME ["/var/cache/apt-cacher-ng"]
EXPOSE 3142

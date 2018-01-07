#!/usr/bin/dumb-init /bin/bash

ACNG_OPTIONS=("ForeGround=1")
init(){
	local REMAPS REMAP VAR_REMAP REMAP_CONFIG TARGETS FLAGS
	[ ! -z "APT_REMAPS" ] && IFS=' ,/;' read -a REMAPS<<<"$APT_REMAPS" \
		&& for REMAP in "${REMAPS[@]}"; do
		[ ! -z "$REMAP" ] && VAR_REMAP="APT_REMAP_${REMAP//-/_}" \
		 	&& VAR_REMAP="${VAR_REMAP^^}" && [ ! -z "${!VAR_REMAP}" ] \
			&& IFS=';,#' read -r REMAP_CONFIG TARGETS FLAGS<<<"${!VAR_REMAP}" && {
				TARGETS="$TARGETS${FLAGS:+ ; $FLAGS}"
				REMAP_CONFIG="$REMAP_CONFIG${TARGETS:+ ; $TARGETS}"
				ACNG_OPTIONS=("${ACNG_OPTIONS[@]}" "Remap-$REMAP=$REMAP_CONFIG")
				echo "Add option: Remap-$REMAP=$REMAP_CONFIG" >&2
			}
	done 
	return 0
}

init && exec /usr/sbin/apt-cacher-ng -c /etc/apt-cacher-ng "${ACNG_OPTIONS[@]}"

#!/bin/bash

set -euo pipefail

external_port=8009

readonly app=local-file-server

args=$(getopt --options hisp: --longoptions help,images,photos,stop,port: --name $(basename "$0") -- "$@")
eval set -- "${args}"

stop=false
mode=files
while :; do
    case "$1" in
        -h | --help)
            ;;
        -i | --images | --photos)
            mode=images
            ;;
        -s | --stop)
            stop=:
            ;;
        -p | --port)
            external_port=$2
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

serve_files()
{
    local -r image=docker.io/library/caddy:current
    local -r internal_port=2000
    local -r web_dir=/web
    local -r podman_args=(
        --rm
        --detach
        --label app="${app}"
        --volume "$(pwd):${web_dir}:ro"
        --publish "${external_port}:${internal_port}"
        --workdir "${web_dir}"
    )

    local -r caddy_args=(
        file-server
        --listen ":${internal_port}"
        --browse "${web_dir}"
    )

    podman run "${podman_args[@]}" "${image}" caddy "${caddy_args[@]}"
}

serve_images()
{
    local -r image=docker.io/viktorstrate/photoview:2
    local -r internal_port=2000
    local -r podman_args=(
        --rm
        --detach
        --label app="${app}"
        --volume "$(pwd):/photos:ro"
        --publish "${external_port}:${internal_port}"
        --env PHOTOVIEW_DATABASE_DRIVER=sqlite
        --env PHOTOVIEW_LISTEN_PORT="${internal_port}"
    )

    local -r app_args=(
    )

    podman run "${podman_args[@]}" "${image}"
}

print_address()
{
    local -r ip=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
    printf 'http://%s:%s/\n' "${ip}" "${external_port}"
}

if ${stop}; then
    podman stop --filter label=app="${app}"
    exit $?
fi

if [[ $mode == images ]]; then
    serve_images
else
    serve_files
fi
print_address

# vim: set et sw=4:

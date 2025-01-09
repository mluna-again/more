function _is_docker_running
    docker info; or return 1

    return 0
end

function _try_start_docker_desktop_app
    if not uname | grep -iq linux
        printf "Docker is not running."
        return 1
    end

    printf "Trying to start docker...\n"
    if systemctl --user start docker-desktop
        printf "Docker started, try again.\n"
        return 0
    else
        printf "Docker could not be started.\n" 2>&1
        return 1
    end
end

function dock
    if not _is_docker_running &>/dev/null
        _try_start_docker_desktop_app
        return 0
    end

    set -l cmd $argv[1]
    set -l query $argv[2]
    test -z "$cmd"; and begin
        printf "Available CMDs:\n"
        printf "\tup\n"
        printf "\tdown\n"
        printf "\tid\n"
        printf "\tlogs\n"
        printf "\tdelete\n"
        printf "\tstart\n"
        printf "\trestart\n"
        printf "\tstatus\n"
        printf "\tstop\n"
        printf "\tports\n"
        printf "\texec\n"
        printf "\tpostgres\n"
        printf "\tdb\n"
        printf "\ttest\n"
        printf "Usage:\n"
        printf "\tdock <cmd>\n"
        printf "\tdock <cmd> [<initial_query>] # automatically selects first match\n"
        printf "\tdock postgres\n"
        printf "\tdock db # same as above\n"
        printf "\tdock db [<PGUSER> <PGPORT> <PGDATABASE> <PGPASSWORD>] # you can use env variables or pass the arguments directly\n"
        printf "\tDOCK_DB_USE_PGCLI=0 dock db # force psql inside container even if pgcli is installed\n"
        return 1
    end

    switch "$cmd"
        case up
            docker compose up

        case down
            docker compose down

        case test
            set -l cmd "$query"
            if test -z "$cmd"
              set cmd "mix test"
              echo "no cmd provided. defaulting to $cmd" 2>&1
            end

            set -l id (
                docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | awk 'NR > 1' | \
                    fzf --header="Choose container to test" | \
                    awk '{print $1}'
            )

            if test -z "$id"
                return 1
            end

            docker container exec --detach-keys="ctrl-@" -it "$id" sh -c "$cmd"

        case postgres db
            set -l use_pgcli 1
            if not command -v pgcli &>/dev/null; and test -z "$DOCK_DB_USE_PGCLI"
                set use_pgcli 0
                echo "pgcli not installing, defaulting to psql inside container." 2>&1
            end

            if test "$DOCK_DB_USE_PGCLI" = 0
                set use_pgcli 0
            end

            set -l pguser "$argv[2]"
            set -l pgport "$argv[3]"
            set -l pgdatabase "$argv[4]"
            set -l pgpassword "$argv[5]"

            test -z "$pguser"; and set pguser "$PGUSER"
            test -z "$pguser"; and set pguser postgres

            test -z "$pgport"; and set pgport "$PGPORT"
            test -z "$pgport"; and set pgport 5432

            test -z "$pgdatabase"; and set pgdatabase "$PGDATABASE"
            test -z "$pgdatabase"; and set pgdatabase postgres

            test -z "$pgpassword"; and set pgpassword "$PGPASSWORD"

            set -l container (
                docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" | \
                    awk 'NR > 1' | \
                    grep -- "->$pgport" |
                    fzf --header="PostgreSQL containers" --with-nth=2
            )

            if test -z "$container"
                return 1
            end

            set -l id (echo "$container" | awk 'NR==1 { print $1 }')
            set -l hostport (echo "$container" | \
                awk 'NR==1 {print $3}' | \
                awk -F',' '{print $1}' | \
                awk -F'->' '{print $1}' | \
                awk -F':' '{print $2}')

            if test "$use_pgcli" = 1
                PGUSER="$pguser" PGPASSWORD="$pgpassword" PGPORT="$hostport" PGDATABASE="$pgdatabase" pgcli -h 127.0.0.1
            else
                docker container exec -e PGUSER="$pguser" -e PGDATABASE="$pgdatabase" -e PGPORT="$pgport" -e PGPASSWORD="$pgpassword" -it "$id" psql
            end

        case exec
            set -l shell "$query"
            if test -z "$shell"
                set shell bash
                echo "no shell provided. defaulting to bash" 2>&1
            end

            set -l id (
                docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | awk 'NR > 1' | \
                    fzf --header="Choose container to exec into" | \
                    awk '{print $1}'
            )

            if test -z "$id"
                return 1
            end

            docker container exec --detach-keys="ctrl-@" -it "$id" "$shell"

        case ports
            set -l line (docker container ls --format "table {{.Names}}\t{{.Ports}}" | \
                awk 'NR>1' | \
                fzf --header="Copy port (first one)")
            if test -z "$line"
                return 1
            end

            set -l port (echo "$line" | awk '{print $2}' | awk -F, '{print $1}' | grep -Eo ":[0-9]+->[0-9]+")

            if test -z "$port"
                echo "could not parse port: $port"
                return 1
            end

            set -l parsed (echo "$port" | awk -F'->' '{print $1}' | sed 's/^://')
            if not echo "$parsed" | grep -Eq '[0-9]+'
                echo "invalid port found: $parsed"
                return 1
            end

            echo "$parsed"
            if isatty 1
                echo -n "$parsed" | fish_clipboard_copy
                echo "Copied to clipboard."
            end

        case status
            if test -z "$query"
                echo no argument 2>&1
                return 1
            end

            docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | awk 'NR > 1' | grep -i "$query" | awk '{ printf "%s: %s\n", $2, $3 }'

        case rm
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Remove container(s)" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )
            test -z "$id"; and return

            docker container rm --force $id

        case logs
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="See container logs" |\
                    awk '{print $1}' |\
                    xargs
            )
            test -z "$id"; and return

            docker container logs "$id"

        case id
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Copy container ID" |\
                    awk '{print $1}' |\
                    xargs
            )

            test -z "$id"; and return
            echo "$id"

            if isatty 1
                echo -n "$id" | fish_clipboard_copy
                echo "Copied to clipboard."
            end

        case exec
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Enter container" |\
                    awk '{print $1}' |\
                    xargs
            )

            test -z "$id"; and return
            set -l shell $argv[2]
            if test -z "$shell"
                set shell bash
            end

            docker container exec -it "$id" "$shell"

        case restart
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Restart container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container restart $container

        case start
            set -l container (
                docker container ls --filter status=exited --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Start container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container start $container

        case stop
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Stop container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container stop $container

        case '*'
            printf "Invalid command.\n"
            return 1
    end
end

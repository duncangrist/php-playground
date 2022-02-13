# php-playground

A starting point for PHP projects.

    cp .env.dist .env
    sed -i s/DEV_UID=[0-9]*/DEV_UID=$(id -u)/ .env
    make dev
    make test
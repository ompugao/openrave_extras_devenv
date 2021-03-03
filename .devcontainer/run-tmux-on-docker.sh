set -e
bash ../set_xauth.sh
docker-compose --project-name openrave_extras_devenv -f ./docker-compose.yml up -d
docker-compose --project-name openrave_extras_devenv exec --workdir /workspace app tmux



# this is rails 7 basic docker playground
```bash
docker build .
docker compose run --no-deps web rails new . --force --database=postgresql --skip-docker
docker compose build
docker compose up
```

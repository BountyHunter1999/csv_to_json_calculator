start_postgres:
	docker run -e POSTGRES_USER=junkiri -e POSTGRES_PASSWORD=pokemon -e POSTGRES_DB=junkiri -p 5432:5432 -v $$(pwd)/entry.sql:/docker-entrypoint-initdb.d/entry.sql -v $$(pwd)/raw.csv:/data.csv postgres:16-alpine3.19


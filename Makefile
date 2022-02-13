test:
	docker-compose run --rm app phpunit --bootstrap vendor/autoload.php tests
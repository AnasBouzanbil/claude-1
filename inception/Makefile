build :
	cd srcs && docker compose build --no-cache

up :
	cd srcs && docker compose up -d

down :
	cd srcs && docker compose down
re : down build up 

rm :
	./srcs/requirements/tools/rm.sh > /dev/null 2>&1 || true


rmall : rm
	sudo rm -rf /home/$(USER)/data
	mkdir -p /home/$(USER)/data/wordpress
	mkdir -p /home/$(USER)/data/mariadb
	docker rm -f $(docker ps -aq)
	docker rmi $(docker images -q)
	docker volume rm $(docker volume ls -q)
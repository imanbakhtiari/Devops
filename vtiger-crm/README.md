version: '3.8'

services:
  vtiger:
    image: nimeshk8/vtigercrm
    container_name: vtiger
    ports:
      - "8080:80"
    environment:
      - DB_HOST=mysql
      - DB_NAME=vtigerdb
      - DB_USER=vtiger
      - DB_PASSWORD=vtigerpass
    depends_on:
      - mysql
    networks:
      - vtiger-network
    volumes:
      - vtiger_data:/var/www/html

  mysql:
    image: mysql:5.7
    container_name: vtiger-mysql
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass
      - MYSQL_DATABASE=vtigerdb
      - MYSQL_USER=vtiger
      - MYSQL_PASSWORD=vtigerpass
    networks:
      - vtiger-network
    volumes:
      - mysql_data:/var/lib/mysql

networks:
  vtiger-network:
    driver: bridge

volumes:
  vtiger_data:
  mysql_data:


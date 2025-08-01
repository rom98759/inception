s

wordpress:
    build:
      context: ./requirements/wordpress
    container_name: wordpress
    env_file:
      - .env
    depends_on:
      - mariadb
    networks:
      - inception
    volumes:
      - wordpress_data:/var/www/html

  wordpress_data:

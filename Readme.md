

Commandes \

Redis cache
docker exec nginx cat /var/www/html/wp-config.php | grep WP_REDIS_HOST


docker exec nginx curl -s -X POST http://portfolio:3000/api/send-email -H "Content-Type: application/json" -d '{"name":"Test","email":"test@test.com","subject":"Test","message":"Test message"}'
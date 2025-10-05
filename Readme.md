

Commandes \



docker exec nginx curl -s -X POST http://portfolio:3000/api/send-email -H "Content-Type: application/json" -d '{"name":"Test","email":"test@test.com","subject":"Test","message":"Test message"}'
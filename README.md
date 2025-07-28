# ProxyAI - CORS Proxy Server

A lightweight nginx-based proxy server to solve CORS issues when accessing AI services from web browsers.

## Problem Solved

When users access your ChatSite from external PCs, browsers block direct requests to `https://ai.byteshell.eu` due to CORS (Cross-Origin Resource Sharing) restrictions. This proxy server acts as an intermediary, allowing your frontend to make requests to the same domain.

## Architecture

```
Browser → ChatSite (your-domain.com) → ProxyAI (your-domain.com:8080/api/) → ai.byteshell.eu
```

## Features

- **CORS Headers**: Automatically adds proper CORS headers to all responses
- **Streaming Support**: Optimized for AI streaming responses with disabled buffering
- **Health Checks**: Built-in health check endpoint at `/health`
- **Docker Ready**: Containerized for easy deployment
- **Production Ready**: Includes proper timeouts and error handling

## Quick Start

1. **Build and run the proxy server:**
   ```bash
   cd ProxyAI
   docker-compose up -d --build
   ```

2. **Update your ChatSite environment variables:**
   ```bash
   # In ChatSite/.env
   REACT_APP_AI_SERVICE_URL=http://your-domain.com:8080
   REACT_APP_AI_ENDPOINT=/api/generate
   ```

3. **Test the proxy:**
   ```bash
   # Health check
   curl http://localhost:8080/health
   
   # Test AI endpoint
   curl -X POST http://localhost:8080/api/generate \
     -H "Content-Type: application/json" \
     -d '{"model": "deepseek-r1:8b", "prompt": "Hello"}'
   ```

## Configuration

### Environment Variables

The proxy server doesn't require environment variables, but you'll need to update ChatSite:

```env
# ChatSite/.env
REACT_APP_AI_SERVICE_URL=http://your-proxy-domain.com:8080
REACT_APP_AI_MODEL=deepseek-r1:8b
REACT_APP_AI_ENDPOINT=/api/generate
REACT_APP_DEBUG=false
```

### Production Deployment

For production, update the nginx configuration:

1. Change `server_name localhost;` to your actual domain
2. Consider using SSL/TLS (port 443)
3. Update the port mapping in docker-compose.yml if needed

## API Endpoints

- `GET /health` - Health check endpoint
- `POST /api/generate` - Proxied AI generation endpoint
- `GET /` - Server status

## Troubleshooting

### Common Issues

1. **Port conflicts**: If port 8080 is in use, change it in docker-compose.yml
2. **CORS still blocked**: Ensure ChatSite is using the proxy URL
3. **Streaming not working**: Check that proxy_buffering is off in nginx.conf

### Logs

```bash
# View proxy logs
docker-compose logs -f proxy

# Check nginx error logs
docker exec proxyai-server tail -f /var/log/nginx/error.log
```

## Security Considerations

- The current configuration allows all origins (`*`) for development
- In production, restrict CORS origins to your specific domains
- Consider implementing rate limiting for production use
- Use HTTPS in production environments

## Integration with ChatSite

After starting ProxyAI, update your ChatSite configuration to use the proxy:

1. Update environment variables to point to ProxyAI
2. Rebuild ChatSite container
3. Test that external users can now access the AI service

The proxy eliminates CORS issues while maintaining all streaming functionality!

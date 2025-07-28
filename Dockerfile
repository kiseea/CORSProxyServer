FROM nginx:alpine

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf.bak 2>/dev/null || true

# Create log directory
RUN mkdir -p /var/log/nginx

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

FROM nginx
EXPOSE 80
COPY --chown=nginx styles.css /usr/share/nginx/html
COPY --chown=nginx index.html /usr/share/nginx/html

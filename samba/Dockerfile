FROM alpine:latest
COPY create-users.sh /create-users.sh
RUN apk update && apk add samba && chmod +x /create-users.sh
CMD ["/bin/sh", "-c", "/create-users.sh && chmod -R 777 /mnt/media && sleep infinity"]

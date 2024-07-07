FROM postman/newman:alpine

COPY postman_collection.json /etc/newman/postman_collection.json

ENTRYPOINT [ "newman", "run", "/etc/newman/postman_collection.json" ]
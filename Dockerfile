FROM directus/directus:latest

EXPOSE 8055
CMD npx directus bootstrap && npx directus start

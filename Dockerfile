# build stage
FROM node:10.16.0-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN yarn
COPY . .
RUN npm run build

# Production stage
FROM nginx:1.16.1-alpine as production-stage
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx.conf /etc/nginx/conf.d/
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD [ "nginx", "-g", "daemon off;"]

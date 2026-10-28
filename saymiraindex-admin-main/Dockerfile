# ---------- Angular build ----------

FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm i --legacy-peer-deps  

RUN npm install ng-recaptcha --save

COPY . .

# build for /admin routing

RUN npm run build -- --configuration production --base-href /admin/

# ---------- Nginx serve ----------

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/saymiraindex-admin /usr/share/nginx/html
 
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

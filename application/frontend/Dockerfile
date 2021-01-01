FROM node:15.4.0 AS compile-image
WORKDIR /opt/ng
COPY ./ui/package.json ./
RUN npm install
ENV PATH="./node_modules/.bin:$PATH" 
COPY ./ui ./
RUN ng build --prod

FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=compile-image /opt/ng/dist/ui /usr/share/nginx/html
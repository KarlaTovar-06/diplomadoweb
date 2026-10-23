# Frontend React + Vite: build en Node y sirve el resultado con nginx
FROM node:22-alpine AS build

WORKDIR /app

# Dependencias (capa cacheable)
COPY package.json ./
RUN npm install

# Código fuente + build de producción
COPY . .
ARG VITE_API_URL=/api
ENV VITE_API_URL=${VITE_API_URL}
RUN npm run build

# Imagen final: solo nginx con los estáticos
FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

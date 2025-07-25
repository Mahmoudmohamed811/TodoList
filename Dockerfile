# Build stage
FROM node:18-slim AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev  # production-only dependencies

COPY . .

# Run stage (lighter final image)
FROM node:18-slim

WORKDIR /app

COPY --from=build /app /app

EXPOSE 4000

CMD ["npm", "start"]

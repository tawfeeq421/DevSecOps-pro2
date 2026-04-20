FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build 

FROM node:20-alpine AS runner 
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_moules
COPY --from=builder /app/. .

RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD [ "npm", "start" ]

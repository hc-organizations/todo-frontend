# Stage 1: Build the Next.js app
FROM node:20-alpine AS builder
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache libc6-compat

# Copy package files and install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --ignore-engines

# Build-time variables for embedding into the app
ARG NEXT_PUBLIC_API_URL
ARG API_URL

# Expose build-time variables as environment variables
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
ENV API_URL=$API_URL

# Copy source code and run the build
COPY . .
RUN yarn build

# Stage 2: Prepare production runner image
FROM node:20-alpine AS runner
WORKDIR /app

# Copy build artifacts and dependencies
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

# Set production environment
ENV NODE_ENV=production

# Expose the application port
EXPOSE 3000

# Start the Next.js server
CMD ["yarn", "start"]
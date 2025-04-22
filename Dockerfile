# Stage 1: Build the Next.js app
FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies (use npm ci if package-lock.json is present)
# 시스템 의존성 및 yarn 설치
RUN apk add --no-cache libc6-compat

# package 파일 복사
COPY package.json yarn.lock ./

# 의존성 설치 (캐시 활용을 위해 package.json과 yarn.lock만 먼저 복사)
RUN yarn install --frozen-lockfile --ignore-engines

# Copy source code and build
COPY . .
RUN yarn build

# Stage 2: Run the Next.js app
FROM node:20-alpine AS runner
WORKDIR /app

# Copy the build output and necessary files from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

# Set environment to production and expose port
ENV NODE_ENV=production
EXPOSE 3000

# Start the Next.js server (which serves SSR pages)
CMD ["yarn", "start"]

---
description: How to build and deploy ITSS AI
---

# Build and Deployment Workflow

Follow these steps to generate builds and deploy the ITSS AI application.

## 1. Frontend Build
Navigate to the frontend directory and run the build script. This will generate a `dist` folder with optimized static assets.

```bash
cd frontend
npm install
npm run build
```

## 2. Backend Build (Docker)
The backend is designed to run in a container. Build the Docker image from the root or backend directory.

```bash
docker build -t itss-ai-backend ./backend
```

## 3. Deployment Options

### Option A: Docker Compose (Internal/VPS)
Use this for quick deployment on a Virtual Private Server (VPS).

// turbo
```bash
docker-compose up -d --build
```

### Option B: Cloud Hosting (AWS/GCP/Azure)
1. **Database**: Provision a managed PostgreSQL instance (e.g., AWS RDS).
2. **Backend**: Push the Docker image to a container registry (ECR/GCR) and deploy to a service like **AWS App Runner** or **Google Cloud Run**.
3. **Frontend**: Upload the `frontend/dist` content to **AWS S3** or **Google Cloud Storage** and serve via a CDN (CloudFront/Cloud CDN).

## 4. Sourcing Keys & RDBMS
- **AI Keys**: Obtain from [Google AI Studio](https://aistudio.google.com/) or [OpenAI Platform](https://platform.openai.com/).
- **Database**: Use [Neon](https://neon.tech) for a free/fast start or [AWS RDS](https://aws.amazon.com/rds/) for enterprise scale.

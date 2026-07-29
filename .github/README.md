## Automated CI/CD Pipeline for Containerized ASP.NET Application

A proof of concept that evaluates whether an AI coding agent (**Claude Code CLI**) can automate DevOps infrastructure tasks by generating a complete containerized deployment workflow.

The project explores AI-assisted generation of:

- Dockerfile for application containerization
- Docker Compose for multi-container deployment
- NGINX reverse proxy configuration
- GitHub Actions CI/CD pipeline
- Automatic Docker image build and push to GitHub Container Registry (GHCR)
- SSH-based deployment to a Linux VPS
- Automated API health checks after deployment
- Automatic rollback on failed deployments.


> [!NOTE]
>  The SSL certificate included in this project is a **self-signed certificate** generated using `openssl`. It is intended for local development and testing only and should be replaced with a trusted SSL certificate in production.
> 
> The generated infrastructure scripts were manually reviewed, validated, and refined to ensure reliable results.
> 
> The server will go down on July 31


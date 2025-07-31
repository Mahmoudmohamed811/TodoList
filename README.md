## Todo List Application Deployment

This project demonstrates a full deployment pipeline for a Node.js Todo List application, integrating Docker, Ansible, GitHub Actions, and automated updates with Watchtower. The goal was to containerize the application, automate its build and deployment, and ensure continuous updates on a Linux VM.

## Project Overview

The project involves cloning a Node.js Todo List application, containerizing it with Docker, setting up a CI pipeline with GitHub Actions, configuring a Linux VM using Ansible, and deploying the application with Docker Compose. Watchtower is used to monitor and update the container image automatically.

### Key Features
- **Dockerized Application**: Containerized the Node.js Todo List app for portability and consistency.
- **CI Pipeline**: Automated image building and pushing to a private Docker registry using GitHub Actions.
- **Infrastructure Automation**: Configured a Linux VM with Ansible to install Docker and dependencies.
- **Automated Updates**: Implemented Watchtower for continuous monitoring and updating of the container image.
- **Health Checks**: Configured Docker Compose with health checks to ensure the application is running correctly.

## Part 1: Dockerizing the Application and CI Pipeline

### Objective
Clone the [Todo-List-nodejs repository](https://github.com/Ankit6098/Todo-List-nodejs), connect it to a MongoDB database, containerize the application, and set up a GitHub Actions pipeline to build and push the Docker image to a private registry.

### Implementation
- **MongoDB Configuration**: Used a MongoDB Atlas cluster with the connection string stored in a `.env` file:
  ```
  mongoDbUrl = mongodb+srv://Mahmouddb:Password@cluster0.ln9cpce.mongodb.net/todolistDb
  ```
- **Dockerfile**: Created a multi-stage Dockerfile to optimize the image size:
  - Build stage: Uses `node:18-slim` to install production dependencies.
  - Run stage: Copies the built app and exposes port 4000.
- **.dockerignore**: Excluded unnecessary files like `node_modules`, `.env`, and logs to reduce image size.
- **GitHub Actions**: Configured a CI pipeline with the following workflow (`Build and Push Docker Image`):
  - Trigger: Runs on push to the `main` branch.
  - Environment: Uses `ubuntu-latest` runner.
  - Steps:
    1. Checks out the code using `actions/checkout@v3`.
    2. Logs in to Docker Hub using secrets `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
    3. Builds the Docker image with the tag `mahmoudmabdelhamid/todo-nodejs:latest`.
    4. Pushes the image to the private Docker registry.

## Part 2: VM Configuration with Ansible

### Objective
Set up a Linux VM (CentOS) and use Ansible to install Docker and configure the environment, running the playbook from a local machine.

### Implementation
- **Ansible Playbook**: Created a playbook to:
  - Install `dnf-plugins-core` for package management.
  - Add the Docker CE repository.
  - Install Docker and related packages (`docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`).
  - Enable and start the Docker service.
  - Add the user `mahmoud` to the Docker group for non-root access.
- **Execution**: Ran the playbook from the local machine against the VM using SSH.

## Part 3: Deployment and Auto-Updates with Docker Compose

### Objective
Deploy the application on the VM using Docker Compose, configure health checks, and implement automatic image updates using a tool of choice.

### Implementation
- **Docker Compose**: Configured a `docker-compose.yml` file to:
  - Run the `todo-app` service using the `mahmoudmabdelhamid/todo-nodejs:latest` image.
  - Map port `4000` for external access.
  - Set `restart: always` for resilience.
  - Implement health checks using `curl` to verify the app's availability every 30 seconds.
- **Watchtower for Auto-Updates**: Chose Watchtower to monitor the Docker registry for image updates:
  - **Justification**: Watchtower is lightweight, integrates seamlessly with Docker, and supports polling the registry at configurable intervals (set to 60 seconds). It automatically pulls and redeploys updated images, ensuring minimal downtime.
  - Configured Watchtower to clean up old images (`WATCHTOWER_CLEANUP=true`) and monitor restarting containers (`WATCHTOWER_INCLUDE_RESTARTING=true`).

## Challenges and Solutions
- **MongoDB Connection**: Ensured secure storage of credentials in `.env` and excluded it from the Docker image for security.
- **Docker Image Size**: Used a multi-stage Dockerfile to reduce the final image size by excluding development dependencies.
- **Ansible Compatibility**: Tested the playbook to ensure compatibility with CentOS and avoid package conflicts.
- **Watchtower Configuration**: Adjusted polling interval to balance update frequency and resource usage.

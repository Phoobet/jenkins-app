FROM jenkins/jenkins:lts

USER root

# ติดตั้ง Docker ภายใน Jenkins Container (ถ้าจะใช้ docker-in-docker)
RUN apt-get update && \
    apt-get install -y docker.io

# กลับมาใช้ jenkins user
USER jenkins

FROM jenkins/jenkins:lts

USER root

# install Jenkinsfile dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip docker-cli git && \
    pip3 install --no-cache-dir --break-system-packages flake8 bandit safety && \
    rm -rf /var/lib/apt/lists/*


# Allow Jenkins to use Docker socket
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins

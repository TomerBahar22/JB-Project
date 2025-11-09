pipeline {
  agent any

  environment {
    DOCKERHUB_CRED = credentials('dockerhub-credentials')
    IMAGE_NAME = 'tomerbahar2/python-web:latest'
  }

  stages {
    stage('Clone Repository') {
      steps {
        url: 'https://github.com/TomerBahar22/JB-Project.git'
      }
    }

    stage('Setup Environment') {
      steps {
        sh '''
          echo "Installing Python dependencies..."
          pip install --break-system-packages flake8 bandit
        '''
      }
    }

    stage('Linting') {
      steps {
        sh '''
          echo "Running linting checks..."

          # Python linting
          flake8 . || true

          # Dockerfile linting (hadolint)
          if [ -f Dockerfile ]; then
            docker run --rm -i hadolint/hadolint < Dockerfile
          else
            echo "No Dockerfile found"
          fi

          # Shell linting (shellcheck)
          files="$(git ls-files '*.sh' || true)"
          if [ -n "$files" ]; then
            for f in $files; do
              echo "shellcheck $f"
              docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable \
                /bin/sh -lc "shellcheck /mnt/$f"
            done
          else
            echo "No .sh files found"
          fi
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t ${IMAGE_NAME} .'
      }
    }

    stage('Security Scan (code)') {
      steps {
        sh '''
          echo "Running Bandit security scan..."
          bandit -r . -ll -iii
        '''
      }
    }

    stage('Security Scan (image)') {
      steps {
        sh '''
          echo "Running Trivy image scan..."
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            aquasec/trivy:latest image --no-progress \
            --severity HIGH,CRITICAL --exit-code 1 ${IMAGE_NAME}
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        sh '''
          echo "Logging in and pushing image..."
          echo "$DOCKERHUB_CRED_PSW" | docker login -u "$DOCKERHUB_CRED_USR" --password-stdin
          docker push ${IMAGE_NAME}
          docker logout
        '''
      }
    }
  }

  post {
    success {
      echo ' Pipeline completed successfully!'
    }
    failure {
      echo ' Pipeline failed! Check logs for details.'
    }
  }
}

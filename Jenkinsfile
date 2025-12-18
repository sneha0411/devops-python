pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-ksa

  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock

  - name: docker-config
    emptyDir: {}

  containers:
  - name: docker
    image: docker:26.1.4-cli
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    - name: docker-config
      mountPath: /root/.docker

  - name: gcloud
    image: google/cloud-sdk:slim
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /root/.docker
"""
    }
  }

  environment {
    PROJECT_ID = "project-b9c15744-8559-4eae-9ba"
    REGION     = "us-central1"
    REPO       = "devops-python"
    IMAGE_NAME = "python-app"
    TAG        = "${BUILD_NUMBER}"
    IMAGE_URI  = "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${TAG}"
  }

  stages {

    stage('Checkout Source Code') {
      steps {
        checkout scm
      }
    }

    stage('Authenticate to Artifact Registry') {
      steps {
        container('gcloud') {
          sh '''
            gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        container('docker') {
          sh '''
            docker build -t ${IMAGE_URI} .
          '''
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        container('docker') {
          sh '''
            docker push ${IMAGE_URI}
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Image pushed successfully: ${IMAGE_URI}"
    }
    failure {
      echo "❌ Build or push failed"
    }
  }
}

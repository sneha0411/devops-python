pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-ksa
  containers:
  - name: builder
    image: google/cloud-sdk:slim
    command: ["sh", "-c", "sleep infinity"]
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
"""
    }
  }

  environment {
    PROJECT_ID = "project-b9c15744-8559-4eae-9ba"
    REGION     = "us-central1"
    REPO       = "devops-python"
    IMAGE      = "python-app"
    TAG        = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Authenticate to Artifact Registry') {
      steps {
        container('builder') {
          sh '''
            gcloud auth list
            gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet
          '''
        }
      }
    }

    stage('Build Image') {
      steps {
        container('builder') {
          sh '''
            docker build \
              -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG} .
          '''
        }
      }
    }

    stage('Push Image') {
      steps {
        container('builder') {
          sh '''
            docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG}
          '''
        }
      }
    }
  }
}

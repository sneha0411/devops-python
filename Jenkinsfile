pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-ksa
    containers:
    - name: docker
    image: docker:26.1.4-cli
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-sock
        mountPath: /var/run/docker.sock

    - name: gcloud
    image: google/cloud-sdk:slim
    command:
    - cat
    tty: true

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
    IMAGE      = "app"
    TAG        = "latest"
  }

  stages {

    stage('Checkout Source Code') {
      steps {
        checkout scm
      }
    }

    stage('Verify Workspace') {
      steps {
        container('docker') {
          sh '''
            pwd
            ls -l
          '''
        }
      }
    }

    stage('Build Image') {
      steps {
        container('docker') {
          sh '''
            docker build \
              -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG} .
          '''
        }
      }
    }
    stage('Authenticate to Artifact Registry') {
    steps {
        container('docker') {
        sh '''
            gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
        '''
        }
      }
    }


    stage('Push Image') {
      steps {
        container('docker') {
          sh '''
            
            docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE}:${TAG}
          '''
        }
      }
    }
  }
}

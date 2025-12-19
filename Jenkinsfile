pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-ksa
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
      - cat
    tty: true
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  volumes:
  - name: workspace-volume
    emptyDir: {}
"""
    }
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --dockerfile=Dockerfile \
              --context=/home/jenkins/agent/workspace/hello-world-build \
              --destination=us-central1-docker.pkg.dev/project-b9c15744-8559-4eae-9ba/devops-python/python-app:${BUILD_NUMBER}
          '''
        }
      }
    }
  }
}

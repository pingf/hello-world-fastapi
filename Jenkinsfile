pipeline {
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/pingf/hello-world-fastapi.git'
      }
    }

    stage('Building image') {
      steps {
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry('http://172.19.0.1:8082', registryCred) {
            dockerImage.push()
          }
        }

      }
    }

  }
  environment {
    registry = 'meng/helloworld-fastapi'
    registryCred = 'DOCKER_CRED'
  }
}
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
          docker.build registry + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry(registry2, registryCred) {
            dockerImage.push()
          }
        }

      }
    }

  }
  environment {
    registry2 = 'http://172.19.0.1:8082'
    registry = '172.19.0.1:8082/meng/helloworld-fastapi'
    registryCred = 'DOCKER_CRED'
  }
}
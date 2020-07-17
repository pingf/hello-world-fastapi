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
          docker.build registryImage + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry(registry, registryCred) {
            dockerImage.push()
          }
        }

      }
    }

  }
  environment {
    registry = 'http://172.19.0.1:8082'
    registryImage = '172.19.0.1:8082/meng/helloworld-fastapi'
    registryCred = 'DOCKER_CRED'
  }
}
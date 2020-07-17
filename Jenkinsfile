pipeline {
  agent {
    docker {
      image 'python:3.8-slim'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER} .'
        sh 'docker run --rm 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER} sleep 1'
      }
    }

    stage('Test') {
      steps {
        sh 'docker run --rm 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER} sleep 1'
      }
    }

    stage('Deploy') {
      steps {
        sh '''docker login -u="admin" -p="hello" 172.19.0.1:8082 &&
docker push 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER}'''
      }
    }

  }




  environment {
    registry = "172.19.0.1:8082/meng/helloworld-fastapi"
    registryUser = ‘admin’
    registryPassword = ‘hello’
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/pingf/hello-world-fastapi.git'
      }
    }
    stage('Building image') {
      steps{
        script {
          docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( registryUser, registryPassword ) {
            dockerImage.push()
          }
        }
      }
    }
  }







}
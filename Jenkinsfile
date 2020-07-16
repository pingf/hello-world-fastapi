pipeline {
  agent {
    docker {
      image 'python:3.8-slim'
    }

  }
  stages {
    stage('Build') {
      parallel {
        stage('Build') {
          steps {
            sh 'docker build -t 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER} .'
          }
        }

        stage('test') {
          steps {
            sh 'docker run --rm 172.19.0.1:8082/meng/helloworld-fastapi:${BUILD_NUMBER} sleep 1'
          }
        }

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
}
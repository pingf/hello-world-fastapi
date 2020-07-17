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
          dockerImage = docker.build registry + "/" + imageName + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Publishing Image') {
      steps {
        script {
          docker.withRegistry("http://" + registry, registryCred) {
            dockerImage.push()
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        input "Deploy to prod?"
        script {
          withKubeConfig([
            credentialsId: 'MYKUBE', 
            serverUrl: 'https://172.19.0.41:6443',
            namespace: 'twwork'
            ]) {
            sh 'kubectl apply -f deploy.yaml'
          }

        }
      }
    }

  }
  environment {
    registry = '172.19.0.1:8082'
    imageName = 'meng/helloworld-fastapi'
    registryCred = 'DOCKER_CRED'
  }
}
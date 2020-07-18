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
          dockerImage = docker.build imageName + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Run Test in Docker') {
      steps {
        script {
          sh "docker run --rm " + imageName + ":$BUILD_NUMBER pytest -v"
        }

      }
    }

    stage('Publishing Image') {
      parallel {
        stage('Publishing Image') {
          steps {
            script {
              docker.withRegistry("http://" + registry, registryCred) {
                dockerImage.push()
              }
            }

          }
        }

        stage('publish to test registry') {
          steps {
            script {
              input 'publish to test registry?'
              docker.withRegistry("http://" + registryTest, registryCred) {
                dockerImage.push()
              }
            }

          }
        }

        stage('publish to prod registry') {
          steps {
            script {
              input 'publish to prod registry?'
              docker.withRegistry("http://" + registryProd, registryCred) {
                dockerImage.push()
              }
            }

          }
        }

      }
    }

    stage('Clean Local Image') {
      steps {
        script {
          sh "docker rmi " + registry + "/" + imageName + ":$BUILD_NUMBER"
        }

      }
    }

    stage('Deploy') {
      steps {
        input 'Deploy to prod?'
        script {
          withKubeConfig([
            credentialsId: 'MYKUBE',
            serverUrl: 'https://172.19.0.41:6443',
            namespace: 'twwork'
          ]) {
            sh 'cat deploy.yaml  | sed -e "s/\\\${version}/'+"$BUILD_NUMBER"+'/" >> twdeploy.yaml'
            sh 'cat twdeploy.yaml'
            sh 'kubectl apply -f twdeploy.yaml'
          }
        }

      }
    }

  }
  environment {
    registry = '172.19.0.1:8082'
    registryTest = '172.19.0.1:8084'
    registryProd = '172.19.0.1:8086'
    imageName = 'meng/helloworld-fastapi'
    registryCred = 'DOCKER_CRED'
  }
}
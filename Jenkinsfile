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
              docker.withRegistry("http://" + registryTest, registryCred) {
                dockerImage.push()
              }
            }

          }
        }

        stage('publish to prod registry') {
          steps {
            script {
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

      parallel {
        stage('deploy to dev') {
          steps {
            script {
              withKubeConfig([
                credentialsId: 'MYKUBE',
                serverUrl: 'https://172.19.0.41:6443',
                namespace: 'twwork'
              ]) {
                sh 'cat deploy.yaml  | sed -e "s/\\\${namespace}/'+namespace+'/" | sed -e "s/\\\${registry}/'+registry+'/" | sed -e "s/\\\${version}/'+"$BUILD_NUMBER"+'/" >> twdeploy.yaml'
                sh 'cat twdeploy.yaml'
                sh 'kubectl apply -f twdeploy.yaml'
              }
            }
          }
        }
        stage('deploy to test') {
          steps {
            input 'Deploy to test?'
            script {
              withKubeConfig([
                credentialsId: 'MYKUBE',
                serverUrl: 'https://172.19.0.41:6443',
                namespace: 'twwork'
              ]) {
                sh 'cat deploy.yaml  | sed -e "s/\\\${namespace}/'+namespaceTest+'/" | sed -e "s/\\\${registry}/'+registryTest+'/" | sed -e "s/\\\${version}/'+"$BUILD_NUMBER"+'/" >> twdeploy-test.yaml'
                sh 'cat twdeploy-test.yaml'
                sh 'kubectl apply -f twdeploy-test.yaml'
              }
            }
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
    namespace = 'default'
    namespaceTest = 'twtest'
    namespaceProd = 'twprod'
  }
}
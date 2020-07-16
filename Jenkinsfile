pipeline {
    agent {
        docker { image 'python:3.8-slim' }
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t 172.19.0.1:8082/meng/helloworld-fastapi:${env.BUILD_NUMBER} .'
            }
        }
        stage('Test') {
            steps {
                sh 'docker run -it 172.19.0.1:8082/meng/helloworld-fastapi:${env.BUILD_NUMBER} sleep 1'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker push 172.19.0.1:8082/meng/helloworld-fastapi:${env.BUILD_NUMBER} .'
            }
        }
    }
}
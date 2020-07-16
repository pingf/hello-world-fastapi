pipeline {
    agent {
        docker { image 'python:3.8-slim' }
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t 172.19.0.1:8082/meng/helloworld-fastapi .'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
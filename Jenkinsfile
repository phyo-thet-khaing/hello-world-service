pipeline {
    agent any

    tools {
        maven "maven3.9"
    }

    environment {
        IMAGE_NAME = "hello-world-service"
        TAG = "${BUILD_ID}"
        DOCKER_IMAGE = "phyothetkhaing/${IMAGE_NAME}:${TAG}"
        
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'docker-hub-cred',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )
                    ]) {
                        sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy to STAGING') {
    steps {
        withCredentials([
            file(
                credentialsId: 'kubeconfig-staging',
                variable: 'KUBECONFIG'
            )
        ]) {
            sh '''
            export KUBECONFIG=$KUBECONFIG

            kubectl config current-context

            kubectl apply -f deployment.yaml -n staging
            kubectl apply -f service.yaml -n staging

            kubectl rollout status deployment/hello-world -n staging
            '''
        }
    }
}
    }

    post {
        success {
            echo "Pipeline SUCCESS 🚀"
        }
        failure {
            echo "Pipeline FAILED ❌"
        }
    }
}
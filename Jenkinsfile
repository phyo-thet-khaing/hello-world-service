pipeline {
    agent any

    tools {
        maven "maven3.9"
    }

    environment {
        IMAGE_NAME = "hello-world-service"
        TAG = "${BUILD_ID}"
        DOCKER_IMAGE = "phyothetkhaing/${IMAGE_NAME}:${TAG}"
        KUBE_DEPLOYMENT = "deployment.yaml"
        KUBE_SERVICE = "service.yaml"
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
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/hello-world \
                    hello-world=${DOCKER_IMAGE} -n staging
                    """
                }
            }
        }

        stage('Wait for Deployment') {
            steps {
                sh "sleep 20"
            }
        }

        // stage('Performance Test') {
        //     steps {
        //         sh "chmod +x performance-test.sh"
        //         sh "./performance-test.sh"
        //     }
        // }
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
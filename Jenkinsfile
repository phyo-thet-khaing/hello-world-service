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

        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
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
                    kubectl config use-context kind-helloworld-staging
                    kubectl apply -f deployment.yaml --server=https://helloworld-staging-control-plane:6443 --validate=false --insecure-skip-tls-verify=true
                    kubectl apply -f service.yaml  --validate=false --server=https://helloworld-staging-control-plane:6443 --insecure-skip-tls-verify=true
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
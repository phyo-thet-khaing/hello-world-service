pipeline {
    agent any

    tools {
        maven "maven3.9"
    }

    environment {
        DOCKER_REGISTRY = "phyothetkhaing/hello-test"
        DOCKER_HOST_PORT = "9096"
    }

    stages {
        // Stage 1: Checkout code from Git
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/phyo-thet-khaing/hello-world-service.git'
            }
        }

        // Stage 2: Build Jar
        stage('Build Jar') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        // Stage 3: Build the Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_REGISTRY}:v1.0 ."
                }
            }
        }

        // Stage 4: Push Docker Image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-cred',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $DOCKER_USER/hello-test:v1.0
                    '''
                    }
                }
            }
        }



        //  stage('Deploy to Staging') {
        //     steps {
        //         withKubeConfig([credentialsId: 'kubeconfig-staging']) {
        //             sh '''
        //                 kubectl config current-context
        //                 kubectl get nodes
        //                 kubectl apply -f deployment.yml --server=https://helloworld-staging-control-plane:6443 --validate=false --insecure-skip-tls-verify=true
        //             '''
        //         }
        //     }
        // }

        stage('Deploy to STAGING') {
    steps {
        withCredentials([
            file(
                credentialsId: 'kubeconfig-staging',
                variable: 'KUBECONFIG'
            )
        ]) {
                    sh '''
                    kubectl config use-context 
                    kubectl apply -f deployment.yaml --server=https://helloworld-staging-control-plane:6443 --validate=false --insecure-skip-tls-verify=true
                    kubectl apply -f service.yaml  --validate=false --server=https://helloworld-staging-control-plane:6443 --insecure-skip-tls-verify=true
                    ''' 
                }
    }

    }
}
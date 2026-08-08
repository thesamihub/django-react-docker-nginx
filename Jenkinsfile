pipeline {

    agent { label 'docker-ec2-2' }
    
    environment {
        PROD_SERVER = "ubuntu@44.220.147.217"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning code...'
                git url: 'https://github.com/thesamihub/django-react-docker-nginx.git',
                    branch: 'main'
                echo 'Code cloned successfully.'
            }
        }
        stage('Build Images') {
            steps {
                echo 'Building Docker images...'

                sh '''
                    docker build -t thesamihub/django_app_backend:$IMAGE_TAG .
                    docker build -t thesamihub/django_app_frontend:$IMAGE_TAG ./mynotes
                '''

                echo 'Images built successfully.'
            }
        }

        stage('Push Images') {
            steps {
                echo 'Pushing images to Docker Hub...'

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhubcred',
                    usernameVariable: 'HUB_USER',
                    passwordVariable: 'HUB_PASS'
                )]) {

                    sh '''
                        echo "$HUB_PASS" | docker login -u "$HUB_USER" --password-stdin

                        docker push thesamihub/django_app_backend:$IMAGE_TAG
                        docker push thesamihub/django_app_frontend:$IMAGE_TAG

                        docker logout
                    '''
                }

                echo 'Images pushed successfully.'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sshagent(['agent-ssh-key']) {
                    
                    sh '''
                        ssh -o StrictHostKeyChecking=no $PROD_SERVER << EOF
                        
                        cd /home/ubuntu/django-react-docker-nginx

                        export IMAGE_TAG = $IMAGE_TAG
                        
                        docker compose -f docker-compose-prod.yml pull
    
                        docker compose -f docker-compose-prod.yml up -d --remove-orphans --force-recreate
    
                        docker compose -f docker-compose-prod.yml exec -T django_app_backend python manage.py migrate
                        
                        EOF
                    '''
    
                    echo 'Deployment completed.'
                }
            }
        }
    }

    post {

        always {
            echo 'Cleaning Docker build cache...'

            sh '''
                docker builder prune -af || true
                docker image prune -af || true
            '''
        }

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}

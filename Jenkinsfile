pipeline {

    agent { label 'docker-ec2-2' }
    
    environment {
        PROD_SERVER = "ubuntu@44.220.147.217"
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

        stage('Create Environment') {
            steps {
                withCredentials([file(credentialsId: 'django-prod-env', variable: 'ENV_FILE')]) {
                    sh '''
                        cp "$ENV_FILE" .env
                        chmod 600 .env
                    '''
                }
            }
        }
        stage('Build Images') {
            steps {
                echo 'Building Docker images...'

                sh '''
                    docker build -t thesamihub/django_app_backend:latest .
                    docker build -t thesamihub/django_app_frontend:latest ./mynotes
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

                        docker push thesamihub/django_app_backend:latest
                        docker push thesamihub/django_app_frontend:latest

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

                        docker compose -f docker-compose-prod.yml pull
    
                        docker compose -f docker-compose-prod.yml up -d --remove-orphans
    
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

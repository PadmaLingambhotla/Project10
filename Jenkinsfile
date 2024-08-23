pipeline {
    agent any
    environment {
        AZURE_CREDENTIALS_ID = 'a06dc198-2b36-4a2f-82d0-e45fbce24d35'
        TERRAFORM_PATH = 'D:\\Software\\terraform_1.9.4_windows_amd64'
        // Optional: You can define AZ_PATH if needed for other commands or tasks.
        // AZ_PATH = 'C:\\Program Files\\Microsoft SDKs\\Azure\\CLI2\\wbin'
    }

    stages {
        stage('Azure CLI Login') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: "${AZURE_CREDENTIALS_ID}")]) {
                    bat '"C:\\Program Files\\Microsoft SDKs\\Azure\\CLI2\\wbin\\az.cmd" login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/PadmaLingambhotla/Project10.git']]])
            }
        }

        stage('Terraform Init') {
            steps {
                withEnv(["PATH+TERRAFORM=${TERRAFORM_PATH}"]) {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withEnv(["PATH+TERRAFORM=${TERRAFORM_PATH}"]) {
                    bat 'terraform validate'
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}

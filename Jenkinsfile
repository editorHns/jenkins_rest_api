pipeline {
    agent any

    parameters {
        string(name: 'MESSAGE', defaultValue: 'Hello from Jenkins', description: 'Текст сообщения')
        choice(name: 'ENVIRONMENT', choices: ['test', 'stage', 'prod'], description: 'Окружение')
        booleanParam(name: 'DEBUG', defaultValue: false, description: 'Включить DEBUG')
    }

    stages {
        stage('Show parameters') {
            steps {
                echo "MESSAGE=${params.MESSAGE}"
                echo "ENVIRONMENT=${params.ENVIRONMENT}"
                echo "DEBUG=${params.DEBUG}"
            }
        }

        stage('REST API') {
            steps {
                echo "Build parameters were received through Jenkins REST API."
                echo "POST /job/${env.JOB_NAME}/buildWithParameters"
            }
        }

        stage('Result') {
            steps {
                echo "Pipeline completed successfully."
            }
        }
    }

    post {
        success { echo "SUCCESS" }
        failure { echo "FAILED" }
    }
}

pipeline {
    agent any
    stages {
        stage('Get TBS-built image') {
           agent {
                docker { 
                   image 'benjvi/kp'
                }
           }
           steps {
             sh "echo \"test-version-file\" > img-version"
             script {
               IMG_VERSION = sh(script: "echo \"test-version-file\"", returnStdout: true)
             }
             sh "echo \"read: ${IMG_VERSION}\""
           }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh "echo \"from env: ${IMG_VERSION}\""
                sh "cat img-version"
            }
        }
    }
}

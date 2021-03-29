pipeline {
    agent any
    environment {
      IMG_VERSION = "ci"
    }

    stages {
        stage('Get TBS-built image') {
           agent {
                docker { 
                   image 'benjvi/kp'
                }
           }
           steps {
             sh "echo \"test-version-file\" > img-version"
             IMG_VERSION = sh "echo \"test-version-file\""
           }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh "cat img-version"
                sh "echo ${IMG_VERSION}"
            }
        }
    }
}

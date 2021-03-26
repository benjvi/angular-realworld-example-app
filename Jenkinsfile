pipeline {
    agent any

    stages {
        stage('Test') {
            agent {
                docker { 
                   image 'node:12.7-alpine'
                   args '-u root:root'
                }
            }
            steps {
                // should be ng test here, but that requires additional deps in this app's case
                sh "NODE_ENV=development npm install && ./node_modules/@angular/cli/bin/ng build"
            }
        }
        stage('Get TBS-built image') {
           agent {
                docker { 
                   image 'benjvi/kp'
                }
           }
           steps {
             withCredentials([file(credentialsId: 'tbs_kubeconfig', variable: 'KUBECONFIG')]) {
               // build is most likely in-progress, so attachto the logs
               sh "kp build logs angular-demo"
               // check i we attached to the correct build and it completed successfully, if not retry
               sh "./scripts/ci/check-latest-image-build.sh || kp image trigger angular demo"
               sh "sleep 5; kp build logs angular-demo; ./scripts/ci/check-latest-image-build.sh"
               sh "./scripts/ci/get-latest-image-version.sh"
             }
           }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
                sh "cat img-version"
            }
        }
    }
}

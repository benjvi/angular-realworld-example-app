pipeline {
    agent any

    stages {
        stage('Test') {
            agent {
                docker { 
                   image 'angular/ngcontainer'
                }
            }
            steps {
                sh "ng test"
            }
        }
        stage('Get TBS-built image') {
           agent {
                docker { 
                   image 'benjvi/kp'
                }
           }
           steps {
             withCredentials([usernameColonPassword(credentialsId: 'tbs_kubeconfig', variable: 'KUBECONFIG_CONTENT')]) {
               sh "echo "${KUBECONFIG_CONTENT}" > ~/.kube/config"
               // build is most likely in-progress, so attachto the logs
               sh "kp build logs angular-demo"
               // check i we attached to the correct build and it completed successfully, if not retry
               sh "./scripts/ci/check-latest-image-build.sh || kp image trigger angular demo"
               sh "sleep 5; kp build logs angular-demo; ./scripts/ci/check-latest-image-build.sh"
               sh "./scripts/ci/get-latest-image-version.sh"
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

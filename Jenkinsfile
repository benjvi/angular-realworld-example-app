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
                   image 'angular/ngcontainer'
                }
           }
           steps {
               // build is most likely in-progress, so attach to the logs
               sh "kp build logs angular-demo"
               // check i we attached to the correct build and it completed successfully, if not retry
               sh "./scripts/ci/check-latest-image-build.sh || kp image trigger angular demo"
               sh "sleep 5; kp build logs angular-demo; ./scripts/ci/check-latest-image-build.sh"
               sh "IMG=\$(kp image status angular-demo | grep "| awk '{print \$2}'); echo \$IMG; echo \$IMG > img-version"
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

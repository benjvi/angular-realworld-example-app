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
               sh "sleep 3; ./scripts/ci/check-latest-image-build.sh || kp image trigger angular-demo"
               sh "sleep 5; kp build logs angular-demo; ./scripts/ci/check-latest-image-build.sh"
               script {
                 IMG_VERSION = sh(script: "./scripts/ci/get-latest-image-version.sh", returnStdout: true)
               } 
             }
           }
        }
        stage('Deploy') {
            agent {
                docker { 
                   image 'benjvi/prify'
                   args '-u root:root'
                }
            }
            steps {
              withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'ssh-key-for-gitops', \
                                             keyFileVariable: 'SSH_KEY_FOR_GITOPS')]) {
                echo 'Deploying....'
                sh "cd / && GIT_SSH_COMMAND='ssh -i $SSH_KEY_FOR_GITOPS -o IdentitiesOnly=yes -o StrictHostKeyChecking=no' git clone git@github.com:benjvi/apps-gitops.git"
                sh "ls /apps-gitops"
                sh "kustomize build k8s/base/ > /apps-gitops/nonprod-cluster/angular-app/ci-package.yml"
                cd "/apps-gitops/nonprod-cluster; kustomize create || true; kustomize edit add resource ci-package.yml; kustomize edit set image index.docker.io/benjvi/angular-demo=index.docker.io/benjvi/angular-demo:${IMG_VERSION}"
                // need some details set in env for prify to work correctly
                // not all context is kept between sh commands, so use a one liner
                sh 'cd /apps-gitops/nonprod-cluster && git config user.email "jenkins@localhost" && git config user.name "Jenkins CI Bot - Angular" && GIT_SSH_COMMAND=\'ssh -i $SSH_KEY_FOR_GITOPS -o IdentitiesOnly=yes -o StrictHostKeyChecking=no\' prify run'
              }
            }
        }
    }
}

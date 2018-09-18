pipeline {
  agent {
    node {
      label 'i7'
    }

  }
  stages {
    stage('Git Submodules') {
      steps {
        timestamps() {
          timeout(unit: 'MINUTES', time: 15, activity: true) {
            sh 'git submodule update --init --recursive'
          }

        }

      }
    }
  }
}
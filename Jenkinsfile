pipeline {
  agent {
    node {
      label 'NodeJS'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'npm install'
      }
    }
    stage('Done') {
      steps {
        build 'chatops-bot'
      }
    }
  }
}
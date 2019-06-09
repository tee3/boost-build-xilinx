pipeline {
    agent {
        label 'xilinx-vivado-linux'
    }

    environment {
        SSL_CERT_FILE = '/etc/ssl/certs/inradar-ca.pem'
        XILINXD_LICENSE_FILE = '2100@license-server-0.eastus.inradar.net'
    }

    stages {
        stage('Manual') {
            steps {
                /// @todo asciidoctor is not installed
                // sh 'bjam --verbose-test -j 8'
                //
                // publishHTML([allowMissing: false,
                //              alwaysLinkToLastBuild: true,
                //              keepAll: false,
                //              reportDir: 'bin/asciidoctor-backend-html5',
                //              reportFiles: 'documentation.html,xsdk.html',
                //              reportName: 'Documentation',
                //              reportTitles: ''])
                sh 'true'
            }
        }
        stage('Documentation') {
            steps {
                /// @todo requires a newer Boost.Build
                // sh 'BOOST_BUILD_PATH=$(pwd) && bjam --help xsdk'
                sh 'true'
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash
                source /opt/Xilinx/SDK/2018.3/settings64.sh
                export BOOST_BUILD_PATH=$(pwd)
                cd test && bjam --verbose-test -j 8
                '''
            }
        }
    }
}

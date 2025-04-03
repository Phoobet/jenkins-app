pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'nfp_d3ZfNLvedzrhZpzsJFm5T3XqvAVPf3tN1060'
        NETLIFY_AUTH = credentials('netlify-token')
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                script {
                    echo "================Building the project================"
                    sh 'ls -la'
                    sh 'node --version'
                    sh 'npm --version'
                    sh 'npm ci'
                    sh 'npm run build'
                    sh 'ls -la'
                }
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                script {
                    echo "================Testing the project================"
                    // ตรวจสอบว่า build/index.html มีจริงหรือไม่
                    sh 'test -f build/index.html || exit 1'
                    sh 'npm test'
                }
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                script {
                    echo "================Deploying the project================"
                    // ติดตั้ง netlify-cli แบบ global
                    sh 'npm install -g netlify-cli'
                    sh 'netlify --version'
                    sh '''
                        echo "Deploying to Netlify Site ID: $NETLIFY_SITE_ID"
                        netlify deploy --dir=build --prod --site=$NETLIFY_SITE_ID --auth=$NETLIFY_AUTH
                    '''
                }
            }
        }
    }

    post {
        always {
            junit '**/test-results/*.xml' // ตรวจสอบว่าไฟล์ผลทดสอบอยู่ในตำแหน่งที่ถูกต้อง
        }
    }
}

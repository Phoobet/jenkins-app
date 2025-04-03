pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = 'nfp_d3ZfNLvedzrhZpzsJFm5T3XqvAVPf3tN1060'
        NETLIFY_AUTH = credentials('netlify-token') // ใช้ credentials จาก Jenkins
    }

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    args '--no-cache' // ใช้ --no-cache เพื่อให้มั่นใจว่า image จะไม่ถูก cache และ build ใหม่ทุกครั้ง
                }
            }
            steps {
                script {
                    echo "================Building the project================"
                    sh 'node --version'
                    sh 'npm --version'
                    sh 'npm ci'
                    sh 'npm run build' // build โปรเจกต์
                    sh 'ls -la' // ตรวจสอบว่าไฟล์ build อยู่ในโฟลเดอร์ที่คาดไว้
                }
            }
        }

        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                }
            }
            steps {
                script {
                    echo "================Testing the project================"
                    // ตรวจสอบว่าไฟล์ index.html มีอยู่ในโฟลเดอร์ build
                    sh 'test -f build/index.html || exit 1' // หากไม่พบไฟล์จะทำให้ test fail
                    sh 'npm test' // รันการทดสอบ
                }
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                }
            }
            steps {
                script {
                    echo "================Deploying the project================"
                    // ติดตั้ง Netlify CLI
                    sh 'npm install -g netlify-cli'
                    sh 'netlify --version' // ตรวจสอบว่า netlify-cli ติดตั้งสำเร็จ
                    echo "Deploying to Netlify Site ID: $NETLIFY_SITE_ID"
                    // เรียกใช้คำสั่ง netlify deploy เพื่อ deploy โปรเจกต์
                    sh 'netlify deploy --dir=build --prod --site=$NETLIFY_SITE_ID --auth=$NETLIFY_AUTH'
                }
            }
        }
    }

    post {
        always {
            // บันทึกผลการทดสอบเป็น JUnit XML
            junit '**/test-results/*.xml'
        }
    }
}

def stage_name 
node("maorsslave"){
    try{
        dir("${env.BUILD_NUMBER}"){
            stage("git clone"){
               
                 sh "git clone https://github.com/maormalca/count_python_withterraform.git"   
                 stage_name = env.STAGE_NAME      
            }
            stage("build"){
                sh "docker build -t counterpython:${env.BUILD_NUMBER} count_python_withterraform"
                stage_name = env.STAGE_NAME
            }
            stage("deploy"){
                sh "docker run -d -p 8081:8081 --name dcount counterpython:${env.BUILD_NUMBER} "
                stage_name = env.STAGE_NAME
            }
            stage("test"){
                def test = sh(returnStdout: true, script: 'curl localhost:8081/count &> /dev/null && echo $?').trim() 
                if (test != '0' ){
                    error("Build failed webserver is down..")
                }
                else{
                    println("the web server is up")
                }
                
            }
       }   
    }
    
    finally{
        stage("final clean"){
            switch(stage_name){
                case 'build':
                    sh "docker image rm counterpython:${env.BUILD_NUMBER} "
                break
                case 'deploy':
                    sh "docker rm -f dcount && docker image rm counterpython:${env.BUILD_NUMBER}"
                break
            }
        }
    }
}

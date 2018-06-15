#!/usr/bin/env bash


setupEnvrionment () {
    printf '===========================Setup the environment============================== \n'

    cd ..
    sudo apt-get update
    sudo apt-get install software-properties-common
    sudo add-apt-repository -y ppa:certbot/certbot
    sudo apt-get update
    sudo apt-get install -y npm
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    sudo apt-get install -y nodejs nginx python-certbot-nginx build-essential
    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
}

setupApp () {
    printf '===========================Setup the Application ============================== \n'
    git clone https://github.com/JaredP94/ELEN4010-Lab4.git
    cd ELEN4010-Lab4
    npm install
}


configureNginx () {
    printf '================================= Configure nginx ============================== \n'

     sudo bash -c 'cat > /etc/nginx/sites-available/default <<EOF
    server {
        server_name thegaijin.xyz www.thegaijin.xyz;
        location / {
            proxy_pass http://127.0.0.1:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
            proxy_redirect off;
        }
    }
    '

    sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
}

configureCertbot () {
    printf '================================= Configure Certabot ============================== \n'

    sudo certbot --nginx
}

setupStartScript () {
    printf '=========================== Create a startup script =========================== \n'

     sudo bash -c 'cat > /home/ubuntu/startapp.sh <<EOF
    #!/bin/bash

    cd /home/jp140694/ELEN4010-Lab4
    npm start
    '
}

setupStartService () {
    printf '=========================== Configure startup service =========================== \n'

     sudo bash -c 'cat > /etc/systemd/system/ELEN4010-Lab4.service <<EOF
    [Unit]
    Description=reacipe startup service
    After=network.target

    [Service]
    User=jp140694
    ExecStart=/bin/bash /home/jp140694/startapp.sh
    Restart=always

    [Install]
    WantedBy=multi-user.target
    '

    sudo chmod 744 /home/jp140694/startapp.sh
    sudo chmod 664 /etc/systemd/system/ELEN4010-Lab4.service
    sudo systemctl daemon-reload
    sudo systemctl enable ELEN4010-Lab4.service
    sudo systemctl start ELEN4010-Lab4.service

}


run () {
    setupEnvrionment
    setupApp
    configureNginx
    configureCertbot
    setupStartScript
    setupStartService
}

run
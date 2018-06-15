#! /bin/bash

function initialize_worker() {
    printf "***************************************************\n\t\tSetting up host \n***************************************************\n"
    # Update packages
    echo ======= Updating packages ========
    sudo apt-get update

    # Export language locale settings
    echo ======= Exporting language locale settings =======
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    # Install app dependencies
    echo ======= Installing dependencies =======
    sudo apt-get install -y python3-pip
    sudo apt-get install -y npm
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    sudo apt-get install -y nodejs nginx python-certbot-nginx build-essential
    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
}

function clone_app_repository() {
    printf "***************************************************\n\t\tFetching App \n***************************************************\n"
    # Clone and access project directory
    echo ======== Cloning and accessing project directory ========
    if [[ -d ~/app ]]; then
        sudo rm -rf ~/app
        git clone -b master https://github.com/JaredP94/ELEN4010-Lab4.git ~/app
        cd ~/app
        npm install
    else
        git clone -b master https://github.com/JaredP94/ELEN4010-Lab4.git ~/app
        cd ~/app
        npm install
    fi
}

# Install and configure nginx
function setup_nginx() {
    printf "***************************************************\n\t\tSetting up nginx \n***************************************************\n"
    echo ======= Installing nginx =======
    sudo apt-get install -y nginx

    # Configure nginx routing
    echo ======= Configuring nginx =======
    echo ======= Removing default config =======
    sudo rm -rf /etc/nginx/sites-available/default
    sudo rm -rf /etc/nginx/sites-enabled/default
    echo ======= Replace config file =======
    sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
    server {
            listen 80 default_server;
            listen [::]:80 default_server;

            server_name _;

            location / {
                    # reverse proxy and serve the app
                    # running on the localhost
                    proxy_pass http://127.0.0.1:3000/;
                    proxy_set_header HOST \$host;
                    proxy_set_header X-Forwarded-Proto \$scheme;
                    proxy_set_header X-Real-IP \$remote_addr;
                    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            }
    }
EOF'

    echo ======= Create a symbolic link of the file to sites-enabled =======
    sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

    # Ensure nginx server is running
    echo ====== Checking nginx server status ========
    sudo systemctl restart nginx
    sudo nginx -t
}

# Add a launch script
function create_launch_script () {
    printf "***************************************************\n\t\tCreating a Launch script \n***************************************************\n"

    sudo cat > /home/jp140694/launch.sh <<EOF
    #!/bin/bash
    cd /home/jp140694/app
    npm start
EOF
    sudo chmod 744 /home/jp140694/launch.sh
    echo ====== Ensuring script is executable =======
    ls -la ~/launch.sh
}

function configure_startup_service () {
    printf "***************************************************\n\t\tConfiguring startup service \n***************************************************\n"

    sudo bash -c 'cat > /etc/systemd/system/app.service <<EOF
    [Unit]
    Description=app startup service
    After=network.target

    [Service]
    User=jp140694
    ExecStart=/bin/bash /home/jp140694/launch.sh

    [Install]
    WantedBy=multi-user.target
EOF'

    sudo chmod 664 /etc/systemd/system/app.service
    sudo systemctl daemon-reload
    sudo systemctl enable app.service
    sudo systemctl start app.service
    sudo service app status
}

Serve the web app through gunicorn
function launch_app() {
    printf "***************************************************\n\t\tServing the App \n***************************************************\n"
    sudo bash /home/jp140694/launch.sh
}

######################################################################
########################      RUNTIME       ##########################
######################################################################

initialize_worker
clone_app_repository
setup_nginx
create_launch_script
configure_startup_service
launch_app
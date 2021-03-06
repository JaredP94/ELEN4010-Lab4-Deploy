# ELEN4010-Lab4-Deploy
### Walkthrough with Bash scripts / Packer + Ansible for convenient setup and running of a secure nodejs application on GCP

Site can be accessed at [freethenode.ml](https://freethenode.ml/todo)

## Setup Process

### Part 1: Launching a Server with Google Cloud Platform
* Login to the [Google cloud console](https://console.cloud.google.com/) (you can sign up for a free trial if needed)
* Navigate to the *Burger Stack* -> *Compute Engine* -> *VM Instances*
* Select *Create Instance*
* Give the VM a name of your choice
* Select a region of your choice (region latency to your location can be tested with the [gcping tool](http://www.gcping.com/))
* Change your machine type to the *micro* option (1 shared vCPU + 0.6GB RAM)
* Change the boot disk image to *Ubuntu 18.04 LTS*
* Tick the firewall exceptions for allowing *HTTP* and *HTTPS* traffic (this will allow incoming traffic on Port 80 - should you wish to create custom firewall exceptions, [consult this useful article](https://cloud.google.com/vpc/docs/firewalls) - traffic on this port will be redirected using *NGINX* which is used as a reverse proxy, a conevnient load balancer, and an SSL manager)
* Finally, select *Create*

### Part 2: Connecting to your VM Instance
Once the instance has been created and launched, GCP offers a range of [convenient SSH connectivity options](https://cloud.google.com/compute/docs/instances/connecting-advanced)
* Select the *SSH* button under the *Connect* header of the Instance which will launch a new browser window with a terminal to interact with your new Instance

## Bash Script Deployment Method

### Part 1: Managing Terminal Sessions
A future consideration that will be made early is the idea of a terminal running a process, even after it has been closed. `tmux`, a terminal multiplexer, has been chosen to perform this task ([useful tmux cheat sheet](https://tmuxcheatsheet.com/)).
* Run `sudo apt-get install tmux` to install the multiplexer
* Run `tmux` to verify a new session is created
* Run `ctrl + d` to terminate the session

### Part 2: Obtaining Domain Name for App Service
Accessing an app service through an IP address is probably something a user wouldn't come back to - so let's get a domain name for the app service.
* Navaigate to [dot.tk](www.dot.tk) to obtain a free domain name
* Once you've selected a domain name, ensure that you forward the domain name to your server's public IP address
* You can verify the domain name is correctly forwarded by performing a *DNS Lookup* using [MXtoolbox](https://mxtoolbox.com/SuperTool.aspx)

### Part 3: Configure and Run Nodejs App Service
* Run `git clone https://github.com/JaredP94/ELEN4010-Lab4-Deploy.git` to copy the deployment files to the instance
* Run `tmux` to begin a new session
* Run `cd ELEN4010-Lab4-Deploy` to move into the deployment folder
* Run `source setup.sh` to configure and launch the app service as well as install an SSL certificate

Security is a pivotal requirement for data integrity of any app service (among other reasons) - so let's utilise SSL, an industry standard choice, to secure traffic on the app service. This is done through the use of *CertBot* which is provided by EFF (more on that [here](https://certbot.eff.org/docs/intro.html) if you're interested).
* You'll be prompted for your email address and whether you want to be added to a mailing list
* You'll then be prompted to enter the domain name you wish to use which will be tested, verified, and certified
* Once complete and the app service is running, you can close that terminal window (don't worry, it'll still be running)
* Access the app service by navigating to `http://<YOUR INSTANCE PUBLIC IP>/todo`
* You'll notice the page is now flagged as secure

## Packer + Ansible Deployment Method

### Part 1: Installing Packer + Ansible
* Install Packer by following these [instructions](https://www.packer.io/docs/install/index.html)
* Install Ansible by following these [instructions](https://docs.ansible.com/ansible/2.4/intro_installation.html)

### Part 2: Build Ansible provised image with Packer
* Run `git clone https://github.com/JaredP94/ELEN4010-Lab4-Deploy.git` to copy the deployment files to the instance
* Run `cd ELEN4010-Lab4-Deploy` to move into the deployment folder
* Run `cd packer-ansible-deploy` to move into the Packer + Ansible folder
* Run `export PROJECT_ID=<YOUR GCP PROJECT ID>` to store your GCP Project ID as an envrionment variable
* Run `packer validate lab4-base-image.json` to validate the image configuration file
* Run `packer build lab4-base-image.json`to build the custom image
* You're now able to create a new instance with the custom built image

### Congrats - You've sucessfully configured, deployed, and secured an accessible Nodejs App Service

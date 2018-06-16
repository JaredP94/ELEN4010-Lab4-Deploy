# ELEN4010-Lab4-Deploy
### Walkthrough with Bash scripts for convenient setup and running of a secure nodejs application on GCP

Site can be accessed at [freethenode.ml](http://freethenode.ml/todo)

## Setup Process

### Part 1: Launching a Server with Google Cloud Platform
* Login to the [Google cloud console](https://console.cloud.google.com/) (you can sign up for a free trial if needed)
* Navigate to the *Burger Stack* -> *Compute Engine* -> *VM Instances*
* Select *Create Instance*
* Give the VM a name of your choice
* Select a region of your choice (region latency to your location can be tested with the [gcping tool](http://www.gcping.com/))
* Change your machine type to the *micro* option (1 shared vCPU + 0.6GB RAM)
* Change the boot disk image to *Ubuntu 18.04 LTS*
* Tick the firewall exceptions for allowing *HTTP* and *HTTPS* traffic (this will allow incoming traffic on Port 80 - should you wish to create custom firewall exceptions, [consult this useful article](https://cloud.google.com/vpc/docs/firewalls))
* Finally, select *Create*

### Part 2: Connecting to your VM Instance
Once the instance has been created and launched, GCP offers a range of [convenient SSH connectivity options](https://cloud.google.com/compute/docs/instances/connecting-advanced)
* Select the *SSH* button under the *Connect* header of the Instance which will launch a new browser window with a terminal to interact with your new Instance

### Part 3: Managing terminal sessions
A future consideration that will be made early is the idea of a terminal running a process, even after it has been closed. `tmux`, a terminal multiplexer, has been chosen to perform this task ([useful tmux cheat sheet](https://tmuxcheatsheet.com/)).
* 2 Sessions will be required - One to run the app service + One to manage the SSL configuration once the app service is running (this one will be temporary as the session can be terminated once completed)
* Run `sudo apt-get install tmux` to install the multiplexer
* Run `tmux` to verify a new session is created
* Run `ctrl + d` to terminate the session

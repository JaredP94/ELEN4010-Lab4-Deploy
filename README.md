# ELEN4010-Lab4-Deploy
### Walkthrough with Bash scripts for convenient setup and running of a secure nodejs application on GCP

Site can be accessed at [freethenode.ml](http://freethenode.ml/todo)

## Setup Process

### Part 1: Launching a Server with Google Cloud Services
* Login to the [Google cloud console](https://console.cloud.google.com/) (you can sign up for a free trial if needed)
* Navigate to the *Burger Stack* -> *Compute Engine* -> *VM Instances*
* Select *Create Instance*
* Give the VM a name of your choice
* Select a region of your choice (region latency to your location can be tested with the [gcping tool](http://www.gcping.com/))
* Change your machine type to the *micro* option (1 shared vCPU + 0.6GB RAM)
* Change the boot disk image to *Ubuntu 18.04 LTS*
* Tick the firewall exceptions for allowing *HTTP* and *HTTPS* traffic (this will allow incoming traffic on Port 80 - should you wish to create custom firewall exceptions, [consult this useful article](https://cloud.google.com/vpc/docs/firewalls))
* Finally, select *Create*

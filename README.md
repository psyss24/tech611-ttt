# Tic Tac Toe Application

- [Tic Tac Toe Application](#tic-tac-toe-application)
  - [Dependencies](#dependencies)
  - [Getting the script onto the VM](#getting-the-script-onto-the-vm)
    - [Method 1 – SCP](#method-1--scp)
    - [Method 2 – Git](#method-2--git)
  - [Preparing the VM](#preparing-the-vm)
  - [Running the Application](#running-the-application)
  - [Automated Deployment Script](#automated-deployment-script)


The deployment process for the app involves:

- Installing the required software.
- Getting the application code onto the VM.
- Installing the application’s dependencies.
- Starting the application.
- Checking that the application is running.

## Dependencies

The following software is required on the VM:

* Ubuntu – operating system for the VM
* Git – used to clone the application repository
* Nginx – web server
* Node.js 20 – required to run the application
* npm – Node.js package manager, used to install the application’s dependencies

The Node.js dependencies are installed using:
```bash
npm install
```
This reads the application’s package.json file and installs the required packages into node_modules.

## Getting the script onto the VM

There are two methods used to transfer the script onto the VM.

### Method 1 – SCP

The script can be copied from the local computer to the VM using scp.

For example:
```bash
scp -i ~/.ssh/your-key.pem prov-app.sh ubuntu@<VM-IP>:~
```
This uses the SSH private key to authenticate with the VM and copies app.zip into the Ubuntu user’s home directory.

### Method 2 – Git

The application can also be downloaded directly onto the VM from GitHub.

The deployment script uses:
```bash
git clone https://github.com/psyss24/tech611-ttt
cd tech611-ttt
```

This downloads the repository onto the VM, extracts the application ZIP file, and changes into the application directory.
This method means the application does not need to be manually copied from the local machine.


## How the script prepares the VM

The deployment script first updates the package lists and installed packages:
```bash
sudo apt-get update
sudo apt-get upgrade -y
```
Nginx is then installed:
```
sudo apt-get install nginx -y
```
Node.js 20 is installed using NodeSource:

``` bash
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
```
The installed version can be checked with:
```bash
node -v
```
Finally, the application’s dependencies are installed:
```bash
npm install
```

## Running the Application

From inside the application’s directory, run:
```bash
npm start &
```
The npm start command runs the start script defined in package.json.

The ```&``` runs the application as a background process; this allows the terminal to return control to the user while the application continues running.

Without ```&```:
```bash
npm start
```
the terminal remains attached to the application process.

## Automated Deployment Script

The deployment process can be automated using the Bash script included in this repository.

The script:

* Updates the Ubuntu package lists
* Upgrades installed packages
* Installs Nginx
* Clones the GitHub repository
* Installs Node.js 20
* Installs the application’s npm dependencies
* Starts the application in the background

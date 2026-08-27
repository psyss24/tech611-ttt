## User Data 
- User Data refers to the AWS feature that allows you to run a bash script (with root priveliges) on a new VM as soon as the VM is able to
  - this can be accessde on the configuration screen for seetting up a fresh VM 
  - this allows you to run a bash script without having to connect to the VM
### what to expect when using user data on the vm
- Whilst the VM is setting up, you will not be able to connect to the server 
- once nginx is installed you will see the nginx home page
- eventually the reverse proxy is configured and it will redirect you to port 3000, but there is no app running on it yet
- once the repo has been installed and pm2 runs the app, we will see the app running 
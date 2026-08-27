## VM Images & AMIs
- an image is a collection of files/folders, images usually contain an OS (at a minimum), but can include different softwares
- we can create an image that already has the collection of software require to install the app which elimates the need of a bash script for *downloading* the software teh app requires
- we do however need to run the app, this can be done via user data or connecting to the VM as before.
- packer -> lets you take a base machine image, run a custom bash script and then save the updated machine as a new image (or AMI in AWS)
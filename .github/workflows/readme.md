# CI/CD Pipeline

- [CI/CD Pipeline](#cicd-pipeline)
  - [CI](#ci)
  - [CD](#cd)
    - [Merging dev into main](#merging-dev-into-main)
    - [Deployment to the VM](#deployment-to-the-vm)
  - [Overall Pipeline](#overall-pipeline)


we use a GitHub Actions workflow to automatically test and deploy changes which is triggered whenever code is pushed to the dev branch.

The pipeline consists of two jobs:

1. Test: checks that the application passes its tests.
2. Deploy: merges the tested changes into main and deploys them to the production VM.

The workflow is stored in:

.github/workflows/cicd.yml

## CI

The first job is responsible for continuous integration. It checks out the code, installs the application’s dependencies and runs the tests.

The job runs on an Ubuntu GitHub-hosted runner:
```yml
test:
  runs-on: ubuntu-latest
```

The repository is downloaded using the checkout action:
```yml
- name: get code
  uses: actions/checkout@v4
```
The application’s dependencies are then installed using npm ci:
```yml
- name: install dependencies
  run: npm ci
  working-directory: ./app
```

npm ci installs the dependencies defined in package-lock.json; this is preferable to npm install in a CI environment because it provides a more reproducible installation.

The tests are then run:
```yml
- name: run tests
  run: npm run test
  working-directory: ./app
```
If the tests fail, the test job fails and the deployment job does not run.

## CD

The deployment job depends on the test job:
```yml
deploy:
  needs: test
```
This means that the deployment can only take place if the CI tests have successfully completed.

The deployment job also runs on an Ubuntu GitHub-hosted runner:
```yml
runs-on: ubuntu-latest
```
The repository is checked out with its full Git history:
```yml
- name: get code
  uses: actions/checkout@v4
  with:
    fetch-depth: 0
```
`fetch-depth: 0` is used because the workflow needs access to the Git history when merging dev into main.

### Merging dev into main

The workflow configures Git with a username and email so that GitHub Actions can create the merge commit:
```yml
git config user.name "psyss24"
git config user.email "psyss24@nottingham.ac.uk"
```
The latest versions of both branches are then fetched:
```yml
git fetch origin main dev
```
The workflow switches to main:
```yml
git checkout main
```
The changes from dev are then merged into main:
```yml
git merge -X theirs origin/dev
```
Finally, the updated main branch is pushed back to GitHub:
```yml
git push origin main
```
The workflow has the following permission so that it can push changes to the repository:
```yml
permissions:
  contents: write
```
### Deployment to the VM

Once the changes have been merged into main, GitHub Actions connects to the production VM using SSH.

The SSH credentials are stored as GitHub Actions secrets rather than being written directly into the workflow:
```yml
env:
  PRIVATE_KEY: ${{ secrets.PRIVATE_KEY }}
  HOST: ${{ secrets.HOST }}
  USER: ${{ secrets.USER }}
```
The private key is temporarily written to a file and its permissions are restricted:
```yml
echo "$PRIVATE_KEY" > github-ec2.pem
chmod 600 github-ec2.pem
```
The workflow then connects to the VM:
```yml
ssh -o StrictHostKeyChecking=no -i github-ec2.pem ${USER}@${HOST}
```
Once connected, the VM’s repository is updated.

First, the latest information from GitHub is fetched:
```yml
git fetch origin
```
The local repository is then made to exactly match the latest main branch:
```yml
git reset --hard origin/main
```
This ensures that the files on the VM are the same as those in the production main branch.

The workflow then enters the application directory and installs any required dependencies:
```yml
cd /tech611-ttt/app
npm install
```
Finally, PM2 is restarted so that the Node.js application loads the newly deployed code:
```yml
pm2 restart app || pm2 start npm --name "app" -- start
```
The pm2 restart app command restarts the existing application process. If the process does not already exist, the command fails and pm2 start starts a new process named app.

## Overall Pipeline

The complete deployment process can be summarised as:

1. Someone pushes changes to dev.
2. GitHub Actions starts the workflow.
3. The code is checked out onto a GitHub-hosted runner.
4. Node.js dependencies are installed using npm ci.
5. The application tests are run.
6. If the tests pass, the deploy job starts.
7. dev is merged into main.
8. The updated main branch is pushed to GitHub.
9. GitHub Actions connects to the production VM using SSH.
10. The VM fetches the latest main branch.
11. The VM resets its application files to match origin/main.
12. Dependencies are installed.
13. PM2 restarts the application.
14. Nginx continues to act as the reverse proxy, allowing users to access the newly deployed application through port 80.

This means that changes can be tested and deployed to the production VM automatically without manually connecting to the VM and updating the application.
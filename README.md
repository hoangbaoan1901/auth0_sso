# Auth0 SSO with Spring Boot (with Docker and Kubernetes deployment, and CI/CD)

## CI/CD with Github Actions and ArgoCD (25/03/2025)
### CI with Github Actions
The project was build with `gradle`. So whenever the source code is commited to the `master` branch, we had need to proceed these steps:
- First, run `./gradlew build`
- Then, push create a docker container out of the JAR files we just made on the previous step and push to DockerHub.
These step can be automized through Github Actions. The workflow is written in `./.github/workflows/gradle-docker.yml`.
#### New pull request from `development` to `master`
![](src/main/resources/images/github_actions/pull_request.png)
##### Workflow completed
![](src/main/resources/images/github_actions/build_gradle_and_push_docker_image.png)
##### New image update on DockerHub
![](src/main/resources/images/github_actions/image_on_dockerhub.png)
### CD with Argo
First, we have to update the K8s manifest with Github Action by adding this to the workflow 
```yaml
    # Update Kubernetes manifests
    - name: Update Kubernetes resources
      run: |
        sed -i "s|image: hoangbaoan1901/auth0_sso:latest|image: hoangbaoan1901/auth0_sso:${{ github.sha }}|" k8s/base/deployment.yaml
    
    # Commit and push the updated manifests
    - name: Commit files
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add k8s/base/deployment.yaml
        git commit -m "Update image to ${{ github.sha }}" || echo "No changes to commit"
        git push
```
To activate ArgoCD, we need to declare these variables to `argocd-application.yaml` to sync the git repo with local ArgoCD app
```yaml
  source:
    repoURL: https://github.com/hoangbaoan1901/auth0_sso.git
    targetRevision: master
    path: k8s/overlays/dev
```
Additional configs are added add `k8s/overlays/dev`

Results:
![](src/main/resources/images/argo_cd/argocd.png)


To access the web, forward the port of the service using `kubectl port-forward svc/dev-auth0-sso-svc 3000:80`
![](src/main/resources/images/argo_cd/results.png)
## Docker and Kubernetes deployment (17/03/2025)
### Docker
#### Build with Gradle and Docker
![1_docker_build.png](src/main/resources/images/docker/1_docker_build.png)
Image will shows up in Docker Desktop
![2_image_name_and_tag.png](src/main/resources/images/docker/2_image_name_and_tag.png)
####Run container on Docker Desktop
Forward the exposed port (3000)
![3_image_run.png](src/main/resources/images/docker/3_image_run.png)
![4_container_run.png](src/main/resources/images/docker/4_container_run.png)
### Kubernetes
#### Enable Kubernetes on Docker Desktop
![5_k8s_enable.png](src/main/resources/images/docker/5_k8s_enable.png)
#### Create `deployment.yaml` and deploy on Kubernetes
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-k8s-app-container
          image: spring/auth0_sso-docker:latest
          imagePullPolicy: Never
          ports:
            - containerPort: 3000
```
Note: use `imagePullPolicy: Never` to declare that the image is pulled from local docker, not Docker Hub.
![6_forward_port.png](src/main/resources/images/docker/6_forward_port.png)
![7_getall_k8s.png](src/main/resources/images/docker/7_getall_k8s.png)
#### Load Balancing & Service Discovery
Use `replicas: 3`
![9_load_balancing.png](src/main/resources/images/docker/9_load_balancing.png)
To forward port, use `kubectl port-forward deployment/my-app-deployment 3000:3000`, this allows forward port from any of the replicas.


Result
![8_result.png](src/main/resources/images/docker/8_result.png)
## 1. Homepage
![1_homepage.png](src/main/resources/images/1_homepage.png)
## 2. Login page with Auth0 service
![2_login.png](src/main/resources/images/2_login.png)
## 3. Sign up
![3_signup.png](src/main/resources/images/3_signup.png)
![3_singup_2.png](src/main/resources/images/3_singup_2.png)
### Through Gmail
![3_signup_2_gmail.png](src/main/resources/images/3_signup_2_gmail.png)

## 4. Homepage after sign in
![4_homepage.png](src/main/resources/images/4_homepage.png)
## 5. Profile page
![5_profilepage.png](src/main/resources/images/5_profilepage.png)
### With Gmail
![5_profilepage_gmail.png](src/main/resources/images/5_profilepage_gmail.png)
## 6. User management
![6_managepage.png](src/main/resources/images/6_managepage.png)
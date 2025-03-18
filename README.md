# Auth0 SSO with Spring Boot (with Docker and Kubernetes deployment)
#   # Docker and Kubernetes deployment
### Docker
#### Build with Gradle and Docker
![1_docker_build.png](src/main/resources/images/docker/1_docker_build.png)
Image will shows up in Docker Desktop
![2_image_name_and_tag.png](src/main/resources/images/docker/2_image_name_and_tag.png)
### #Run container on Docker Desktop
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
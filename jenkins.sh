# #!/bin/bash

# curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# yum install fontconfig java-17-openjdk jenkins -y
# systemctl daemon-reload
# systemctl enable jenkins
# systemctl start jenkins

#!/bin/bash
set -e

dnf update -y

# install java
dnf install -y java-17-amazon-corretto

# add jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# install jenkins
dnf install -y jenkins

systemctl daemon-reexec
systemctl enable jenkins
systemctl start jenkins
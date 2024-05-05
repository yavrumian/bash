#!/bin/bash
USER=$(whoami)
echo "This is your username: $USER, please enter below your Windows username in case of using WSL:"
read winuser

cp .bashrc .custom.bashrc
sed -i "s/USERNAME/$USER/g" ".custom.bashrc"
sed -i "s/WINUSR/$winuser/g" ".custom.bashrc"

echo -e "Installing essential tools\n"
sudo apt install lolcat figlet vim curl wget -y
echo -e "\n"

# install kubectl
echo "Installing kubectl"
kubectl version --client
if [ $? != 0 ]
then
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	#  init config file
	mkdir "/home/$USER/.kube"
	touch "/home/$USER/.kube/config"
	rm kubectl
fi
echo -e "\n"

# install aws cli 
echo -e "Installing AWS cli\n"
aws --version
if [ $? != 0 ]
then
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm -rf aws awscliv2.zip
fi
echo -e "\n"

# Install WSL-Hello-sudo
echo -e "Installing WSL-Hello-sudo\n"
cat /etc/pam.d/sudo | grep "pam_wsl_hello.so"
if [ $? != 0 ]
then
	wget http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz
	tar xvf release.tar.gz
	cd release
	. ./install.sh
	cd ..
	rm -rf release*
fi
echo -e "\n"

cat /home/$USER/.bashrc | grep "source /home/$USER/bash/.custom.bashrc"
if [ $? != 0 ]
then
	echo -e "\nsource /home/$USER/bash/.custom.bashrc" >> /home/$USER/.bashrc
fi
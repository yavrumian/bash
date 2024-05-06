#!/bin/bash
USER=$(whoami)
echo "This is your username: $USER, please enter below your Windows username in case of using WSL:"
read winuser

cp .bashrc .custom.bashrc
sed -i "s/USERNAME/$USER/g" ".custom.bashrc"
sed -i "s/WINUSR/$winuser/g" ".custom.bashrc"

echo -e "Installing essential tools\n"
sudo apt install lolcat figlet vim curl wget fzf -y
echo -e "\n"

# Symlink to windows home
ln -sf /mnt/c/Users/$winuser/ /home/$USER/win

# Install kubectl
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
ls /usr/share/pam-configs/wsl-hello
if [ $? != 0 ]
then
	wget http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz
	tar xvf release.tar.gz
	cd release
	. ./install.sh
	set +e
	cd ..
	rm -rf release*
fi
echo -e "\n"

# Install krew, kubectl plugin manager
echo -e "Installing krew"
kubectl krew version
if [ $? != 0 ]
then
	(
	set -x; cd "$(mktemp -d)" &&
	OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
	ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
	KREW="krew-${OS}_${ARCH}" &&
	curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
	tar zxvf "${KREW}.tar.gz" &&
	./"${KREW}" install krew
	)
fi
echo -e "\n"

# Install kubens
echo -e "Installing kubens"
kubectl krew list | grep ns
if [ $? != 0 ]
then
	kubectl krew install ns
fi
echo -e "\n"

# Install kubens
echo -e "Installing kubectx"
kubectl krew list | grep ctx
if [ $? != 0 ]
then
	kubectl krew install ctx
fi
echo -e "\n"

# Install neat
echo -e "Installing neat"
kubectl krew list | grep neat
if [ $? != 0 ]
then
	kubectl krew install neat
fi
echo -e "\n"


cat /home/$USER/.bashrc | grep "source /home/$USER/bash/.custom.bashrc"
if [ $? != 0 ]
then
	echo -e "\nsource /home/$USER/bash/.custom.bashrc" >> /home/$USER/.bashrc
fi
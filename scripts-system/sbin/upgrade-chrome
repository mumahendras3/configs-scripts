#!/bin/sh

if [ -f /root/Downloads/extra/google-chrome/google-chrome-stable_current_amd64.deb ]; then
	# Asking for downloading new google-chrome package
	printf "It seems that you have downloaded the google chrome .deb package. Do you want to use that instead? [y|n] "
	read ask
	if [ "ask" = "y" ]; then
		echo "using the already downloaded package\n"
	else
		# Remove existing google chrome package
		rm -rf /root/Downloads/extra/google-chrome/google-chrome-stable_current_amd64.deb
		# Downloading
		echo "Downloading the google chrome debian package\n"
		echo "Opening the download page"
		cd /root/Downloads
		rm -rf /root/Downloads/google-chrome-stable_current_amd64.deb
		while [ ! -f /root/Downloads/google-chrome-stable_current_amd64.deb ]
		do
			echo "Please download the google chrome package first before continuing the upgrade process"
			firefox https://www.google.com/chrome/
		done
		mv /root/Downloads/google-chrome-stable_current_amd64.deb /root/Downloads/extra/google-chrome
	fi
else
	# Downloading
	echo "Downloading the google chrome debian package\n"
	echo "Opening the download page"
	cd /root/Downloads
	rm -rf /root/Downloads/google-chrome-stable_current_amd64.deb
	while [ ! -f /root/Downloads/google-chrome-stable_current_amd64.deb ]
	do
		echo "Please download the google chrome package first before continuing the upgrade process"
		firefox https://www.google.com/chrome/
	done
	mv /root/Downloads/google-chrome-stable_current_amd64.deb /root/Downloads/extra/google-chrome
fi

# Upgrading the chrome
echo "Upgrading the google package, remember to use root access!\n\n"
cd "/root/Downloads/extra/google-chrome"

# Removing already available package in /tmp directory
rm -rf /tmp/google-chrome-*.t?z

# Building and installing the package
./google-chrome.SlackBuild
upgradepkg /tmp/google-chrome-*.t?z

# Done
echo 'The upgrade script has finished! :)'

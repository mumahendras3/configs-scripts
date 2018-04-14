#!/bin/sh

# Remove existing google chrome package
rm -rf /root/Downloads/extra/google-chrome/google-chrome-stable_current_amd64.deb

# Downloading
echo "Downloading the google chrome debian package\n\n"
wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Upgrading the chrome
echo "Upgrading the google package, remember to use root access!\n\n"
mv "./google-chrome-stable_current_amd64.deb" "/root/Downloads/extra/google-chrome"
cd "/root/Downloads/extra/google-chrome"

# Removing already available package in /tmp directory
rm -rf /tmp/google-chrome-*.t?z

# Building and installing the package
./google-chrome.SlackBuild
upgradepkg /tmp/google-chrome-*.t?z

# Done
echo "The upgrade script has finished! :)"

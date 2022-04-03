# Установка PACKER
https://www.packer.io/downloads
```
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install packer
```
* packer --version -просмотр версии

# Установка TERRAFORM
* [Мануал](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  
 или
* sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install terraform
* terraform --version
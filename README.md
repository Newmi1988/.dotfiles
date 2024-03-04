# My configuration files for MacOS and Linux

These configuration files are meant to be used with [stow](https://www.gnu.org/software/stow/)
The folder hierarchy should be same tree as the home directory.

## Install dependencies 🚧
There is a simple ansible script located at the root of the repo.
To install ansible have a look at the offical [documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#pipx-install).
After ansible is avaible you can use it to install all the tools that are used by this configuration.
Go to the directory and run the playbook
```bash
ansible-playbook ./dependencies.yaml

```
## Get the submodules working 🐙
Run the following commands
```
git submodule update --init
```
If you can't clone the repository you may have to change the URI in `.gitmodules`.
My [neovim](https://github.com/neovim/neovim) configuration can be found [here](https://github.com/Newmi1988/nvim_setup) and used separately.

## Create the symbolic links 🚀
I use `stow` to create the symbolic links to apply these configurations.
You can specify the target with the `-t <dir>` option, the default is the parent directory.
Have a look at the [offical docs](https://www.gnu.org/software/stow/manual/stow.html#Invoking-Stow) for help.
I simply store this repository in my home directory, so I have to simply call
```bash
stow .
```

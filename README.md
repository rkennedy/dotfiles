These are my configuration settings.

# Recommended setup

1. A 256-color-capable terminal
2. [Powerline][powerline]. Set `POWERLINE_HOME` in *.bash_profile.local*.
3. Git 1.7.10 or later to support `include.path` configuration.

# Installation instructions

After cloning the repository, do the following:

1. Get all the submodules:

    ```bash
    git submodule init
    git submodule update
    ```

2. Link the following files in the home directory:
    * ackrc
    * bash_profile
    * bashrc
    * colordiffrc
    * gitconfig
    * inputrc
    * screenrc
    * tmux.conf
    * vimrc

3. Create *~/.config* and create a link to *dotfiles/powerline*.

4. Install [Vundle][vundle]:

        git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle

5. Create *~/.bash_profile.local* and set `POWERLINE_HOME` and `COLORFGBF`.

6. Create */.gitconfig.local* and `user.email`.

[powerline]: https://github.com/Lokaltog/powerline
[vundle]: https://github.com/gmarik/Vundle.vim

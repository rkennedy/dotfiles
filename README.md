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
    * tmux.conf
    * vimrc
    * zshenv
    * zshrc

3. Create *~/.config* (or `$XDG_CONFIG_HOME`) and create a link to *dotfiles/powerline*.

    ```bash
    mkdir ~/.config
    ln -s ~/dotfiles/powerline ~/.config/powerline
    ```

4. Set up Vim:

    1. Create an undo folder in a location according to the OS:

        * On Windows, create *`$APPDATA`/Vim/undo*.
        * On Mac, create *~/Library/Vim/undo*.
        * On Linux, create *`$XDG_DATA_HOME`/vim/undo* or
            *~/.local/share/vim/undo* depending on whether `XDG_DATA_HOME` is
            set in your environment.

5. Create *~/.bash_profile.local* and set `POWERLINE_HOME` and call `dark` or
    `light`.

6. Create */.gitconfig.local* and `user.email`.

# Mobile
When using ConnectBot, Powerline fonts are not available. Configure it to run
the `no_powerline_fonts` command on login, which will set an environment
variable that *.vimrc* knows to look for prior to setting the up the display.

[powerline]: https://github.com/Lokaltog/powerline

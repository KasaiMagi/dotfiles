SCRIPT_PATH="${BASH_SOURCE[0]}";
if([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

echo "Installing dotfiles from ${SCRIPT_PATH}"
echo ""

###################### CREATE SYMLINKS

if([ -h ~/.bash_profile ] || [ ! -f  ~/.bash_profile ]) then
  ln -fs ${SCRIPT_PATH}/bash_profile ~/.bash_profile
else
  echo "ERROR: ~/.bash_profile already exists, please remove then install again"
fi

if([ -h ~/.inputrc ] || [ ! -f  ~/.inputrc ]) then
  ln -fs ${SCRIPT_PATH}/inputrc ~/.inputrc
else
  echo "ERROR: ~/.inputrc already exists, please remove then install again"
fi

if([ -h ~/.nanorc ] || [ ! -f  ~/.nanorc ]) then
  ln -fs ${SCRIPT_PATH}/nanorc ~/.nanorc
else
  echo "ERROR: ~/.nanorc already exists, please remove then install again"
fi

if([ -h ~/.screenrc ] || [ ! -f  ~/.screenrc ]) then
  ln -fs ${SCRIPT_PATH}/screenrc ~/.screenrc
else
  echo "ERROR: ~/.screenrc already exists, please remove then install again"
fi

if([ -h ~/.bashrc ] || [ ! -f  ~/.bashrc ]) then
  ln -fs ${SCRIPT_PATH}/bashrc ~/.bashrc
else
  echo "ERROR: ~/.bashrc already exists, please remove then install again"
fi

if([ -h ~/.colordiffrc ] || [ ! -f  ~/.colordiffrc ]) then
  ln -fs ${SCRIPT_PATH}/colordiffrc ~/.colordiffrc
else
  echo "ERROR: ~/.colordiffrc already exists, please remove then install again"
fi

if([ -h ~/.vimrc ] || [ ! -f  ~/.vimrc ]) then
  ln -fs ${SCRIPT_PATH}/vimrc ~/.vimrc
else
  echo "ERROR: ~/.vimrc already exists, please remove then install again"
fi

if([ -h ~/.vim ] || [ ! -d  ~/.vim ]) then
  ln -fs ${SCRIPT_PATH}/vim ~/.vim
else
  echo "ERROR: ~/.vim already exists, please remove then install again"
fi

###################### LOCALRC
if([ ! -f  ~/.localrc ]) then
    touch ~/.localrc
    echo "NOTE: Created ~/.localrc for machine-specific info"
fi

if([ -f  ~/.profile ]) then
    echo "NOTE: ~/.profile exists, any machine-specific info should go in ~/.localrc"
fi

###################### GIT SETUP
if which git &> /dev/null; then
    git config --global alias.br "branch"
    git config --global alias.ci "commit"
    git config --global alias.cia "commit -a -m"
    git config --global alias.ciaa "commit -a --amend -C head"
    git config --global alias.co "checkout"
    git config --global alias.st "status -sb"
    git config --global alias.rb "rebase"
    git config --global alias.rbi "rebase -i"
    git config --global alias.rba "rebase --abort"
    git config --global alias.rbc "rebase --continue"
    git config --global alias.rbs "rebase --skip"
    git config --global alias.cpk "cherry-pick"
    git config --global alias.dt "difftool"
    git config --global alias.diff "diff --word-diff"

    git config --global alias.last '!git lgs -1 --relative-date --graph HEAD'
    git config --global alias.last5 '!git lgs -5 --relative-date --graph HEAD'
    git config --global alias.lg "log --pretty='%C(yellow)%h - %C(blue)%an <%ae>%Creset - %ar%C(red)%d%Creset%n%s%n' --graph"
    git config --global alias.lgs "log --pretty='%C(yellow)%h - %C(blue)%an <%ae>%Creset - %ar%C(red)%d%Creset%n%s%n' --graph --stat"
    git config --global alias.slg "log --pretty='%C(yellow)%h:%C(blue)%an <%ae>%Creset -%C(red)%d%Creset %s %Cgreen(%ar)%Creset' --graph"
    git config --global alias.recent "shortlog --since=yesterday"

    git config --global alias.svnup "!sh -c 'git stash; git svn rebase; git stash pop'"
    git config --global alias.svnci "!sh -c 'git stash; git svn dcommit; git stash pop'"

    git config --global alias.unstage "reset HEAD --"
    git config --global alias.wtf "!sh -c 'git-wtf'"
    git config --global alias.publish-branch "!sh -c 'git-publish-branch'"
    git config --global alias.pb "!sh -c 'git-publish-branch'"
    git config --global alias.serve "!git daemon --reuseaddr --verbose  --base-path=. --export-all ./.git"
    git config --global alias.remote-prune "!git remote | xargs -n 1 git remote prune"

    git config --global color.ui "auto"
    git config --global core.excludesfile "${SCRIPT_PATH}/gitignore"
    git config --global core.autocrlf "input"
    git config --global push.default "current"
    git config --global branch.autosetupmerge "true"
    git config --global branch.autosetuprebase "local"
    git config --global merge.conflictstyle "diff3"
    git config --global merge.stat true
    git config --global core.whitespace trailing-space

    if [ "$1" != '-q' ]; then
        echo "Current Git user settings:"
        echo "user name/email: `git config --global --get user.name` / `git config --global --get user.email`"
        echo "gitub user/token: `git config --global --get github.user` / `git config --global --get github.token`"
        read -p "Change Git info? [n/y] " -e gitchange
        if [ "$gitchange" == "y" ]; then

            read -p "Git: Enter user.name [`git config --global --get user.name`]: " -e input_gitname
            if [ -n "$input_gitname" ]; then
              git config --global user.name "${input_gitname}"
            fi

            read -p "Git: Enter user.email [`git config --global --get user.email`]: " -e input_gitemail
            if [ -n "$input_gitemail" ]; then
              git config --global user.email "${input_gitemail}"
            fi

            read -p "Git: Enter github.user [`git config --global --get github.user`]: " -e input_githubuser
            if [ -n "$input_githubuser" ]; then
              git config --global github.user "${input_githubuser}"
            fi

            read -p "Git: Enter github.token [`git config --global --get github.token`]: " -e input_githubtoken
            if [ -n "$input_githubtoken" ]; then
              git config --global github.token "${input_githubtoken}"
            fi

        fi
        echo ""
    fi
else 
    echo "NOTE: Git not installed, skipping Git setup"
    echo ""
fi

if [ "$1" != '-q' ]; then 
    echo "Finished! To reload settings, run: source ~/.bash_profile"
fi
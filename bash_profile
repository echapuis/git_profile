#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Pulled partly from: https://gist.github.com/natelandau/10654137
#
#  Sections:
#  1.   Environment Configuration
#  2.   Core utils
#  3.   Searching & Navigation
#  4.   Git
#  5.   Productivity Tools
#
#  ---------------------------------------------------------------------------


### -------------------------------
### 1.  ENVIRONMENT CONFIGURATION
### -------------------------------

    #   Set Paths
    #   ------------------------------------------------------------
        export PATH_TO_HAX=~/.hax
        export PATH_TO_CACHE=$PATH_TO_HAX/completions/cache
        export SAMSARA_PROFILE=$PATH_TO_HAX/samsara_profile
        export COMPLETIONS=$PATH_TO_HAX/completions/.common
       
    #   Set Default Editor (change 'Nano' to the editor of your choice)
    #   ------------------------------------------------------------
        export EDITOR="/usr/bin/vim"
        

    #   Set default blocksize for ls, df, du
    #   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
    #   ------------------------------------------------------------
        export BLOCKSIZE=1k

    #   This prefix is prepended to each command related to git branches
    #   e.g. gb, gbd, gmb, etc. (see section on Git)
        export GIT_BRANCH_PREFIX="eliott"
        
    #   Pull configs from .bashrc as well if it is present.
    if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

    #   Used for shifting between completion options in bash
    # if type complete >/dev/null 2>/dev/null; then
    #     bind '"\e[Z": menu-complete'
    # fi

### -----------------------------
### 2.  CORE UTILS
### -----------------------------

    alias cp='cp -iv'                           # Preferred 'cp' implementation
    alias mv='mv -iv'                           # Preferred 'mv' implementation
    alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    # alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
    alias ll='ls -alFGh'
    alias less='less -FSRXc'                    # Preferred 'less' implementation
    alias c='clear'                             # c:            Clear terminal display
    mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
    trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
    
    #   lr:  Full Recursive Directory Listing
    #   ------------------------------------------
    alias lr='ls -R | rg ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

    zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
    alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
    
    #   extract:  Extract most know archives with one command
    #   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

    alias cal='open https://calendar.google.com/calendar'
    alias mail='open https://mail.google.com/mail/u/0/#inbox'

    alias comp='sub $COMPLETIONS'
    alias hax='sub ~/.bash_profile'
    alias shax='sub $SAMSARA_PROFILE'
    alias zhax='sub ~/.zshrc'
    alias fr='sub $PATH_TO_HAX/feature_requests'

    alias refresh='source ~/.bash_profile'
    alias reload='source ~/.zshrc && source ~/.bash_profile && source $SAMSARA_PROFILE && reset' # Note that order matters here

    alias cpwd='pwd | pbcopy'
    alias o='open'
    alias f='open .'

    alias sizeup='open -a "SizeUp"'
    alias sub='open -a "Sublime Text"'
    alias land='open -a "GoLand"'
    alias dpause='docker ps | tail -n +2 | while read con im com cre stat port name; do docker pause $con; done'
    alias dunpause='docker ps | tail -n +2 | while read con im com cre stat port name; do docker unpause $con; done'

    alias remove_whitespace='sed "s/[[:blank:]]//g"'

    #   cleanupDS:  Recursively delete .DS_Store files
    #   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

    # converts a unix timestamp (in ms) to human-readable date
    ts () {
        date -r $(($1 / 1000))
    }

    # prints the number of lines in a file
    linecount () {
        wc -l "$1" | awk '{ print $1 }'
    }

### ---------------------------
### 3.  SEARCHING & NAVIGATION
### ---------------------------

#   SEARCHING
#   ------------------------------------------
    rip () {    
        if [ "$1" = "-l" ]; then
            file_path=$(rg -cli "$2" | fzf | sed 's/:.*//')
            if [ ! $file_path = "" ]; then
                land $file_path
                echo $file_path
            fi
        else
            rg -i "$1"
        fi
    }
    alias ripl='rip -l'

    ripg () {
        files=$(gsp | { while read s f; do echo $(git rev-parse --show-toplevel)/$f; done } | sed "s/ /\\ /g")
        echo $files | while read file; do
            echo $file
            rg $1 $file
        done
    }
    ff () { code `/usr/bin/find . -name '*' "$@" '*' | fzf` ; }      # ff:       Find file under the current directory

#   NAVIGATION
#   ------------------------------------------
    navigate () {
        if [ $# -eq 0 ]; then
            return
        fi

        if [[ -d $1 ]]; then
            cd $1
        else
            cd `dirname $1`
            # code $1
        fi
    }

    cd() { builtin cd "$@"; }
    cdl() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias ..='cd ../'                           # Go back 1 directory level
    alias ...='cd ../../'                       # Go back 2 directory levels
    alias .3='cd ../../../'                     # Go back 3 directory levels
    alias .4='cd ../../../../'                  # Go back 4 directory levels
    alias .5='cd ../../../../../'               # Go back 5 directory levels
    alias .6='cd ../../../../../../'            # Go back 6 directory levels
    alias ~="cd ~"                              # ~:            Go Home

#   -----------------------------
#   4. GIT
#   -----------------------------
    
    # guarantees git status output in a fixed format for scripts
    alias gsp='git status --porcelain'

#   Staging & Pushing Commits
#   (git add, commit, push, reset)
#   ----------------------------- 

    # git push branch - pushes to a new upstream branch
    gpb () {
        branch_name=$(git symbolic-ref --short HEAD)
        echo "Pushing new branch: $branch_name"
        git push --set-upstream origin $branch_name
    }

    # git pull request - opens a url to a PR from the upstream branch
    gpr () {
        branch_name=$(git symbolic-ref --short HEAD)
        echo "Creating PR for branch: $branch_name"
        open "https://www.$(git config --get remote.origin.url | rg -oe 'github.*$' | sed "s/:/\//g; s/\.git$//")/pull/new/$branch_name"
    }

    # git push force - overwrites upstream branch with local branch
    alias gpf='git push -f'

    # Pushes the code to origin upstream and opens up the link to the PR
    alias ship="gpb && gpr"

    # git commit - commit current staged changes to local branch & open editor for commit message
    alias gcm='git commit'
    # git commit message - commit current staged changes to local branch without opening editor
    alias gcmm='git commit -m'

    # git add all - add all changes to staging
    alias gall='git add -A'

    # git save - commits all current changes 
    alias gsave='git add -A && git commit -m "Please fix me"'

    # git reset head hard - deletes all current changes
    # !CAREFUL! there isn't a good way to recover from this
    alias grhh='git add -A && git reset HEAD --hard'

    # git add - adds files to staging; see https://git-scm.com/docs/git-add
    ga () {
        if [ "$1" = "-l" ]; then
            files=$(gsp | rg -v "^[MAR]" | { while read s f; do echo "$f"; done; })
            file_path=$(echo $files | fzf)
            if [ ! $file_path = "" ]; then
                git add $(git rev-parse --show-toplevel)/$file_path
            fi
        else
            git add $1
        fi
    }
    alias gal='ga -l'

    # git reset head - removes files from staging; see https://git-scm.com/docs/git-reset
    grh () {
        if [ "$1" = "-l" ]; then
            files=$(gsp | rg "^[MAR]" | sed "s/^R.*->/R /" | { while read s f; do echo "$f"; done; })
            file_path=$(echo $files | fzf)
            if [ ! $file_path = "" ]; then
                git reset HEAD $(git rev-parse --show-toplevel)/$file_path
            fi
        elif [ "$1" = "-a" ]; then
            git reset HEAD
            return
        else
            git reset HEAD $1
        fi
    }
    alias grhl='grh -l'
    alias grha='grh -a'

    # git add patch - stage specific changes from a file; see https://git-scm.com/docs/git-add#Documentation/git-add.txt-patch
    gap () {
        if [ "$1" = "-l" ]; then
            files=$(gsp | { while read s f; do echo "$(git rev-parse --show-toplevel)/$f"; done; })
            git add -p `echo $files | uniq | fzf`
        else
            git add -p $1
        fi
    }
    alias gapl='gap -l'

#   Viewing Commits/Commit History
#   (git log, show, status, diff)
#   ----------------------------- 

    # git show head - shows the changes from a previous commit
    # default show previous commit, but can specify 'gsh $N' to see diff from N commits ago
    gsh () { 
        if [ $# -eq 1 ]; then
            git show HEAD~$(( $1 - 1 )) 
            return
        fi
        git show HEAD
    }
    # git history - shows the history of a specific file beyond renames; see https://git-scm.com/docs/git-log#Documentation/git-log.txt---follow
    alias gh='git log --follow'

    # git log - shows the commit history for the specified branch (default current branch)
    gl () {
        if [ ! $# -eq 1 ]; then
            git log -5
            return
        fi
        if [ "$1" = "master" ]; then 
            git log -5 $1
        else
            git log -5 $GIT_BRANCH_PREFIX/$1
        fi
    }

    # git diff - shows the changes that haven't been committed yet for a specific file; see https://git-scm.com/docs/git-diff
    gd () {
        last_commit=$(git log --no-decorate -1 | head -1 | sed "s/commit//" | remove_whitespace)
        if [ "$1" = "-l" ]; then
            files=$(gsp | { while read s f; do echo "$f"; done; })
            git diff $last_commit $(git rev-parse --show-toplevel)/`echo $files | fzf`
        else
            git diff $last_commit $1
        fi
    }
    alias gdl='gd -l'

    # git diff staged - shows only the staged changes for a specific file
    gds () {
        last_commit=$(git log --no-decorate -1 | head -1 | sed "s/commit//" | remove_whitespace)
        if [ "$1" = "-l" ]; then
            files=$(gsp | rg "^[MAR]" | { while read s f; do echo "$f"; done; })
            git diff --staged $last_commit $(git rev-parse --show-toplevel)/`echo $files | fzf`
        else
            git diff --staged $last_commit $1
        fi
    }
    alias gdsl='gds -l'

    # git status - using gsl will navigate you to the dir where the selected changes were made
    gs () {
        if [ "$1" = "-l" ]; then
            files=$(gsp | { while read s f; do echo "$(git rev-parse --show-toplevel)/$f"; done; })
            navigate `echo $files | uniq | fzf`
        else
            git status
        fi
    }
    alias gsl='gs -l'
    

#   Manipulating Commit History
#   (git stash, amend, rebase, reset)
#   ----------------------------- 

    # Merge current staged changes into previous commit with same commit message
    alias gaa='git commit -u --amend --no-edit'
    # Merge all changes into previous commit with same commit message
    alias gaaa='git add -A && git commit -u --amend --no-edit'

    # See https://git-scm.com/docs/git-stash for documentation on git-stash    
    alias gst='git stash'
    alias gsta='git stash apply'
    alias gstp='git stash pop'
    alias gstd='git stash drop'

    # See https://git-scm.com/docs/git-cherry-pick for documentation on git-cherry-pick
    alias gcp='git cherry-pick'

    # git rebase interactive - interactively edit historical commits (optionally specify number of commits for lookback)
    # see https://git-scm.com/docs/git-rebase#Documentation/git-rebase.txt---interactive
    grbi () {
        git rebase -i HEAD~"$1"
    }
    alias grbc='git rebase --continue'
    
    # git fix - merges staged changes with a previous commit without changing commit message
    # if trying to rewrite commit message, use grbi instead
    gfix () {
        git commit --fixup=HEAD~$(($1 - 1))
        GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash HEAD~$(($1 + 1))
    }

    # Deprecated - prefer to use gfix instead
    # git dump will dump top of stash stack to previous commit and continue rebasing
    alias gdump='gstp && gaaa && grbc'
    
    # git undo - "undo's" the last N commits by unstaging changes from those commits
    gundo () {
        git reset HEAD~"$1"
    }

#   Branch Management
#   (git branch, checkout)
#   ----------------------------- 
    
    # git branch - shows all working branches in local repo
    alias gb='git branch | sed -e "s/$GIT_BRANCH_PREFIX\///"'

    # git checkout - commits all pending changes and changes branches
    gc () {
        gsave
        if [ "$1" = "master" ]; then 
            git checkout "$1"
        elif [ $# -eq 0 ]; then
            git checkout `git branch | fzf`
        else
            git checkout $GIT_BRANCH_PREFIX/"$1"
        fi
    }

    # git pull origin master - rebases current branch off of upstream master
    gpom () {
        git add -A && git commit -m "Please fix me" 
        git pull origin master --rebase
    }

    # git make branch - saves current changes, updates local master branch, and creates new branch
    gmb () {
        new_branch = $1
        gc master
        gpom
        git checkout -b $GIT_BRANCH_PREFIX/$new_branch
    }

    # git branch delete - shows a confirmation popup with branch log before deleting the specified branch
    gbd () {
        branch_name=$1
        if [ "$1" = "-l" ] || [ "$1" = "" ]; then
            branch_name=$(echo $(gb | sed "s/$GIT_BRANCH_PREFIX\///" | fzf) | remove_whitespace)
            if [ $branch_name = "" ]; then
                return
            fi
        fi
        gl $branch_name
        echo "Confirm delete branch $GIT_BRANCH_PREFIX/$branch_name (1 for Yes, 2 for No)?"
        select yn in "y" "n"; do
            case $yn in
                y ) git branch -D $GIT_BRANCH_PREFIX/$branch_name; break;;
                n ) break;;
            esac
        done
    }
    alias gbdl='gbd -l'
   
#   Misc
#   ----------------------------- 

    # Shows you all of the git conflicts that are currently present
    gconf () {
        periphery=5
        if [ $# -eq 1 ]; then
            periphery=$1
        fi
        git_repo=$(git rev-parse --show-toplevel)
        gsp | sed "s/^R.*->/R /" | while read s f; do rg -C $periphery "=======" $f; done
    }

    # go linter for git changes that haven't been committed yet
    ggolint () {
        git_repo=$(git rev-parse --show-toplevel)
        gsp | rg "^[MAR]" | sed "s/^R.*->/R /" | rg ".*\.go" | { while read s f; do gofmt -s -w $git_repo/$f && goimports -w $git_repo/$f && git add $git_repo/$f; done; }
    }    

    gclean () {
        if [ "$1" = "-a" ]; then
            # clean up all untracked files
            mv `gsp | rg "\?\?" | { while read s f; do echo $(git rev-parse --show-toplevel)/"$f"; done } | sed "s/ /\\ /g"` $PATH_TO_HAX/gclean
            return
        fi
        if [ "$1" = "-l" ]; then
            all_files=$(gsp | { while read s f; do echo $(git rev-parse --show-toplevel)/$f; done } | sed "s/ /\\ /g")
            mv `echo $all_files | fzf` $PATH_TO_HAX/gclean
            return
        fi
        mv $1 $PATH_TO_HAX/gclean/$1
    }
    alias gcleanl='gclean -l'
    alias gcleana='gclean -a'

    rmg () {
        files=$(gsp | { while read s f; do echo "$f"; done; })
        file_path=$(echo $files | fzf)
        if [ ! $file_path = "" ]; then
            rm $(git rev-parse --show-toplevel)/$file_path
        fi
    }

    gcr () {
    	git add -A
        git commit -m "Please fix me" 
        git fetch origin $1:$GIT_BRANCH_PREFIX/$1
        git checkout $GIT_BRANCH_PREFIX/$1
    }
    

### ---------------------------
### 5.  PRODUCTIVITY TOOLS
### ---------------------------

    alias notes='filepath=$PATH_TO_HAX/notes/"$(date +"Notes %Y-%m Week %W")"; touch $filepath && sub $filepath'
    alias note='echo "$1" >> $PATH_TO_HAX/notes/"$(date +"Notes %Y-%m Week %W")"'

    SCD_PATH=$PATH_TO_HAX/scd
    source $SCD_PATH
    scd () {
        if [ ! $# -eq 1 ]; then
            sub $SCD_PATH
            return
        fi
        echo "alias cd$1='cd $(pwd)'" >> $SCD_PATH
        source $SCD_PATH
        echo "ADDED: alias cd$1='cd $(pwd)'"
    }
    

    alias clear_todo='rm $PATH_TO_HAX/todo/todo'
    td () {
        folder_path=$1
        mkdir $folder_path
        touch $folder_path/list
        inpre='^-'
        if [ $# -eq 2 ] && ! [[ "$2" =~ $inpre ]]; then
            echo "$2" >> $folder_path/list
            echo "$(date)\tA\t$2" >> $folder_path/.log
        elif [ "$2" = "-d" ]; then
            re='^[0-9]+$'
            if [[ $3 =~ $re ]] ; then
                line_number=$3    
            else 
                line_number=$(cat $folder_path/list | rg $3 -n | rg -o ".*:" | sed "s/://" | sed "1d")
            fi
            sed "${line_number}d" $folder_path/list > $folder_path/list_temp
            echo "$(date)\tD\t$(cat $folder_path/list | head -$line_number | tail -1)" >> $folder_path/.log   
            cat $folder_path/list_temp > $folder_path/list && rm $folder_path/list_temp
        elif [ "$2" = "-e" ]; then
            sub $folder_path/list
            return
        elif [ "$2" = "-l" ]; then
            sub $folder_path/.log
            return
        elif [ "$2" = "-u" ]; then #todo lel
            last_command=$(cat $folder_path/.log | tail -1)
            sub $folder_path/.log
            return
        fi
        i=1
        while IFS="" read -r p || [ -n "$p" ]
        do
          printf '%d  %s\n' "$i" "$p"
          i=$[$i + 1]
        done < $folder_path/list
    }

    todo () {
        td $PATH_TO_HAX/todo $1 $2
    }

    papers () {
        if [ $# -eq 1 ] && [ "$1"  = "-r" ]; then
            paper_url=$(cat $PATH_TO_HAX/papers/list | head -1)
            open $paper_url
            notes_file=$(echo $paper_url | sed "s/\//-/g")
            mkdir $PATH_TO_HAX/papers/notes
            sub $PATH_TO_HAX/papers/notes/$notes_file
            return
        fi
        td $PATH_TO_HAX/papers $1 $2
    }


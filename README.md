# bz-follow-bugs

Automatically cc yourself on bugs assigned to given users in Bugzilla 

## How to install and configure

* Clone the repository: `git clone https://github.com/bywatersolutions/dev-bz-follow-bugs.git`
* Symlink the shell script to some place in your executable path: `ln -s /path/to/dev-bz-follow-bugs/bin/bz-follow-bugs /usr/local/bin/.`
* Copy the example env file to your home directory: `cp .bz-follow-bugs.env.example ~/.bz-follow-bugs.env`
* Edit that file, change the example values to your values: `vi ~/.bz-follow-bugs.env`
* Try running the command `bz-follow-bugs --help` to see how to use the app

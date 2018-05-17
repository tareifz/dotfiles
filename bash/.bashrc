# Custom Bashrc
# https://wiki.archlinux.org/index.php/User:Grufo/Color_System's_Bash_Prompt

# Terminal Colors
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ] ; then
			STAT=`parse_git_dirty`
			echo -e "[\e[48;5;63m${BRANCH}${STAT}\e[0m]"
	else
			echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function number_of_files() {
		echo -e '\e[48;5;204m$(ls -1 | wc -l | sed "s: ::g") files\e[0m'
}

function files_size() {
		echo -e '\e[30;48;5;15m$(ls -sh | head -n1 | sed "s/total //")\e[0m'
}

function user_or_root() {
		echo "$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)"
}

function print_user() {
		echo -e "\e[30;48;5;82m\u\e[0m"
}

function print_directory() {
		echo -e "\e[48;5;27m\w\e[0m"
}


FIRST_LINE="┌[`print_user`]─[`print_directory`]"
SECOND_LINE="└─[`number_of_files`, `files_size`]─\`parse_git_branch\`─> "

export PS1="\n$FIRST_LINE\n$SECOND_LINE"

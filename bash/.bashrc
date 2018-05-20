# Custom Bashrc
# https://wiki.archlinux.org/index.php/User:Grufo/Color_System's_Bash_Prompt

# Terminal Colors
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# get current branch in git repo
function parse_git_branch() {
		BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
		if [ ! "${BRANCH}" == "" ] ; then
				STAT=`parse_git_dirty`
				echo "[${BRANCH}${STAT}]"
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
		echo '[\[\033[48;5;204m\]$(ls -1 | wc -l | sed "s: ::g") files\[\033[0m\]'
}

function files_size() {
		echo '\[\033[30;48;5;15m\]$(ls -sh | head -n1 | sed "s/total //")\[\033[0m\]]'
}

function user_or_root() {
		echo "$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)"
}

function print_user() {
		echo '\[\033[30;48;5;82m\][\u]\[\033[0m\]'
}

function print_directory() {
		echo '\[\033[48;5;27m\][\w]\[\033[0m\]'
}

export PS1="\n\
┌$(print_user)─$(print_directory)\n\
└─$(number_of_files), $(files_size)─\[\033[48;5;63m\]\`parse_git_branch\`\[\033[0m\]─> "

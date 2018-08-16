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

# \001 stands for \[
# \002 stands for \]

LTGREEN="\001\e[30;48;5;82m\002"
LTBLUE="\001\e[48;5;27m\002"
LTRED="\001\e[48;5;204m\002"
LTGREY="\001\e[30;48;5;15m\002"
PURPLE="\001\e[48;5;63m\002"
RESET_COLOR="\001\e[m\002"

function number_of_files() {
		echo "$(ls -1 | wc -l | sed "s: ::g") files"
}

function files_size() {
		echo "$(ls -sh | head -n1 | sed "s/total //")"
}

# Tihs was a nightmare.. we need to use '\[' and '\]' between UNICODE Chars
# so that the prompt wrap to the next line instead of overwriting the current line.

export PS1="\n\[┌\]$LTGREEN[\u]$RESET_COLOR\[─\]$LTBLUE[\w]$RESET_COLOR
\[└─\][$LTRED\`number_of_files\`$RESET_COLOR, $LTGREY\`files_size\`$RESET_COLOR]\[─\]$PURPLE\`parse_git_branch\`$RESET_COLOR\[─>\] "

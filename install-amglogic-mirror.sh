# Github 增强加速脚本
# 加速地址参考github 增强加速下载脚本
# Created by xe5700
# @namespace    https://greasyfork.org/scripts/412245
# @supportURL   https://github.com/XIU2/UserScript
# @homepageURL  https://github.com/XIU2/UserScript
url_clone="";

url_raw="";
url_raw2="";

clone_mirror(){
	printf "Choose github clone mirror\n
	0. github.com [Orginal]
	1. hub.fastgit.org [China Hong Kong] \n
	2. gitclone.com [China Zhe Jiang] \n
	3. github.com.cnpmjs.org [Singapore]\n
	"
	tryagain=1
	while [ $tryagain -eq 1 ]; do
		$capture = 1;
		case $capture in 
		0) url_clone="https:\\/\\/github.com\\/";;
		1) url_clone="https:\\/\\/hub.fastgit.org\\/";;
		2) url_clone="https:\\/\\/gitclone.com\\/github.com\\/";;
		3) url_clone="https:\\/\\/github.com.cnpmjs.org\\/";;
		*) printf "\nTry again.\n"; tryagain=1;;
		esac
		echo
		echo "Github clone URL -> $url_clone"
		echo
	done
}

raw_mirror(){
	printf "Choose github raw mirror\n
	0. https://raw.githubusercontent.com [Orginal]
	1. https://raw.fastgit.org [China Hong Kong]
	2. https://cdn.staticaly.com [Global]
	3. https://ghproxy.com [South Korea]
	"

	#1. https://cdn.jsdelivr.net [Global]
	tryagain=1
	while [ $tryagain -eq 1 ]; do
		$capture = 1;
		case $capture in 
		0) url_raw="https:\\/\\/raw.githubusercontent.com\\/";url_raw2="https://raw.githubusercontent.com/";;
		1) url_raw="https:\\/\\/raw.fastgit.org\\/";url_raw2="https://raw.fastgit.org/";;
		2) url_raw="https:\\/\\/cdn.staticaly.com\\/gh\\/";url_raw2="https://cdn.staticaly.com/gh/";;
		3) url_raw="https:\\/\\/ghproxy.com\\/https:\\/\\/raw.githubusercontent.com\\/";url_raw2="https://ghproxy.com/https://raw.githubusercontent.com/";;
		*) printf "\nTry again.\n"; tryagain=1;;
		esac
		echo
		echo "Github raw URL -> $url_raw"
		echo
	done
}

clone_mirror
raw_mirror

cd /tmp

wget "${url_raw2}xe5700/kvmd-armbian/master/install-amglogic.sh" -o install.sh

sed "s/https:\\/\\/raw.githubusercontent.com\\//$url_raw/" | sed "s/https:\\/\\/github.com\\//$url_clone/"
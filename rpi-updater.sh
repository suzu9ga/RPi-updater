#!/usr/bin/env bash

#root確認
if (( "${UID}" != 0 )); then
	echo "Root権限(sudo)で実行して下さい" >&2 ; exit 1
fi

run_cmd() {
	echo "${@} を実行中"
	eval ${@}
}

#質問
read -p "ディストリビューションのアップグレードをしますか？(少しリスクがあります)[y/n]:" dist; echo
read -p "ファームウェアのアップデートをしますか?(少しリスクがあります)[y/n]: " firm; echo
read -p "実行後再起動しますか? [y/n]: " rbt; echo

#アプデ本体
echo "アップデートをします"
sleep 1
run_cmd apt-get -y update

echo "アップグレードをします"
sleep 1
run_cmd apt-get -y upgrade

if [[ "${dist}" = "y" ]]; then
	echo "ディストリビューションのアップグレードをします"
	run_cmd apt-get -y dist-upgrade
fi

if [[ "${firm}" = "y" ]]; then
	echo "ファームウェアのアップデートをします"
	run_cmd rpi-update -y
fi

if [[ "${rbt}" = "y" ]]; then
	echo "再起動します"
	sleep 2
	run_cmd reboot
else
	echo "完了しました!終了します"
	sleep 2
	exit
fi

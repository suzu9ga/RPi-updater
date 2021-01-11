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
while :
do
	read -n 1 -p "ディストリビューションのアップグレードをしますか？(少しリスクがあります)[y/n]:" dist; echo
		if [ "${dist}" = "y" ]; then
			break
		elif [ "${dist}" = "n" ]; then
			echo "キャンセルされました"; break
		else
			echo "yかnで入力して下さい"
		fi
done
while :
do
	read -n 1 -p "ファームウェアのアップデートをしますか?(少しリスクがあります)[y/n]: " firm; echo
		if [ "${firm}" = "y" ]; then
			break
		elif [ "${firm}" = "n" ]; then
			echo "キャンセルされました"; break
		else
			echo "yかnで入力して下さい"
		fi
done
while :
do
	read -n 1 -p "実行後再起動しますか? [y/n]: " rbt; echo
		if [ "${rbt}" = "y" ]; then
			break
		elif [ "${rbt}" = "n" ]; then
			echo "キャンセルされました"; break
		else
			echo "yかnで入力して下さい"
		fi
done

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

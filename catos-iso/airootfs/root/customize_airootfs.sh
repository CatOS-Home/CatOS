#!/usr/bin/env bash

## Script to perform several important tasks before `mkarchcraftiso` create filesystem image.

set -e -u

## -------------------------------------------------------------- ##

## lsb-release
rm /etc/lsb-release
touch /etc/catos-lsb-release
ln -s /etc/catos-lsb-release /etc/lsb-release
cat > "/etc/lsb-release" <<- _EOF_
	DISTRIB_ID="CatOS"

	DISTRIB_RELEASE="rolling"
	DISTRIB_DESCRIPTION="CatOS"

_EOF_

## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##

## /etc/os-release
rm /etc/os-release
touch catos-os-release
ln -s /etc/catos-os-release /etc/os-release
cat > "/etc/os-release" <<- _EOF_
	NAME="CatOS"
	PRETTY_NAME="CatOS"
	ID=catos
	BUILD_ID=rolling
	ANSI_COLOR="38;2;23;147;209"
	HOME_URL="https://github.com/CatOS-Home/CatOS"
	DOCUMENTATION_URL="https://github.com/CatOS-Home/CatOS"
	SUPPORT_URL="https://github.com/CatOS-Home/CatOS"
	BUG_REPORT_URL="https://github.com/CatOS-Home/CatOS"
	PRIVACY_POLICY_URL="https://github.com/CatOS-Home/CatOS"
	LOGO=catos

_EOF_

## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##

## /etc/issue
rm /etc/issue
touch /etc/catos-issue
ln -s /etc/catos-issue /etc/issue
cat > "/etc/issue" <<- _EOF_
	CatOS \r (\l)

_EOF_

## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##

## /etc/motd
rm /etc/motd
touch /etc/catos-motd
ln -s /etc/catos-motd /etc/motd
cat > "/etc/motd" <<- _EOF_
To install [38;2;23;147;209mCat OS[0m follow the installation guide:
https://wiki.archlinux.org/title/Installation_guide

For Wi-Fi, authenticate to the wireless network using the [35miwctl[0m utility.
For mobile broadband (WWAN) modems, connect with the [35mmmcli[0m utility.
Ethernet, WLAN and WWAN interfaces using DHCP should work automatically.

After connecting to the internet, the installation guide can be accessed
via the convenience script [35mInstallation_guide[0m.

[41m [41m [41m [40m [44m [40m [41m [46m [45m [41m [46m [43m [41m [44m [45m [40m [44m [40m [41m [44m [41m [41m [46m [42m [41m [44m [43m [41m [45m [40m [40m [44m [40m [41m [44m [42m [41m [46m [44m [41m [46m [47m [0m

_EOF_

## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##
## 更换国内源
echo 'Server = https://mirrors.cernet.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.xjtu.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
echo 'Server = https://mirrors.shanghaitech.edu.cn/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

## -------------------------------------------------------------- ##
##更换主机名
echo "CatOS" > /etc/hostname
## -------------------------------------------------------------- ##

## -------------------------------------------------------------- ##
### 开启multilib仓库支持
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
echo ' ' >> /etc/pacman.conf
## 增加archlinuxcn源
echo '[archlinuxcn]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf


## -------------------------------------------------------------- ##

## 增加arch4edu源
echo '[arch4edu]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/$arch' >> /etc/pacman.conf

## -------------------------------------------------------------- ##

#pip install questionary
#设置时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

#设置系统语言为中文
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

#enable networkmanager
ln -s '/usr/lib/systemd/system/NetworkManager.service' '/etc/systemd/system/multi-user.target.wants/NetworkManager.service'
#enable docker
ln -s '/usr/lib/systemd/system/docker.service' '/etc/systemd/system/multi-user.target.wants/docker.service'

#remove kde welcome
#rm /etc/xdg/autostart/org.kde.plasma-welcome.desktop
rm /etc/xdg/autostart/calamares.desktop

mkdir /home/liveuser/Desktop
mv /etc/xdg/autostart/catos.desktop /home/liveuser/Desktop/catos.desktop
rm /etc/xdg/autostart/catos-advanced.desktop  #暂时移除联网安装
#mv /etc/xdg/autostart/catos-advanced.desktop /home/liveuser/Desktop/catos-advanced.desktop


sed -i 's/#Color/Color/g' /etc/pacman.conf


#sed -i 's/MODULES=()/MODULES=(vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx)/g' /etc/mkinitcpio.conf
#mkinitcpio -p linux


##fcitx5
echo "GTK_IM_MODULE=fcitx" >> /etc/environment
echo "QT_IM_MODULE=fcitx" >> /etc/environment
echo "XMODIFIERS=@im=fcitx" >> /etc/environment
echo "SDL_IM_MODULE=fcitx" >> /etc/environment


##grub
echo 'GRUB_THEME="/usr/share/grub/themes/vimix-color-1080p/theme.txt"' >> /etc/default/grub

###修改plymounth默认主题为catos  /usr/share/plymouth/plymouthd.defaults
#sed -i 's/bgrt/catos/g' /usr/share/plymouth/plymouthd.defaults


##default icon
#sed -i 's/start-here-kde/\/usr\/share\/icons\/catos\/catos.svg/g' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i 's/start-here-kde-symbolic/catos/g' /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
###sddm
#sed -i 's:Current=.*:Current=sugar-candy-catos:g' /etc/sddm.conf.d/kde_settings.conf

###修改默认为x
###sed -i 's:Session=.*:Session=plasmax11:g' /etc/sddm.conf.d/kde_settings.conf





#! /bin/bash

# install electron19

dir_electron19=/opt/electron19
wget https://github.com/electron/electron/releases/download/v19.1.9/electron-v19.1.9-linux-x64.zip

if [ ! -d $dir_electron19 ]; then
    sudo mkdir -p $dir_electron19
    sudo unzip electron-v19.1.9-linux-x64.zip -d $dir_electron19
    sudo ln -s $dir_electron19/electron /usr/local/bin/electron19
fi

# install wechat-uos

pkgname=wechat-uos
_pkgname=wechat
_electron=electron19
pkgver=2.1.5

pkgdir=wechat-uos

wget https://home-store-packages.uniontech.com/appstore/pool/appstore/c/com.tencent.weixin/com.tencent.weixin_2.1.5_amd64.deb

ar -x com.tencent.weixin_2.1.5_amd64.deb

echo "  -> Extracting the data.tar.xz..."
if [ -d $pkgdir ]; then
    rm -rf $pkgdir
fi
mkdir $pkgdir
tar -Jxvf data.tar.xz -C "${pkgdir}"
mv ${pkgdir}/opt/apps/com.tencent.weixin/files/weixin/resources/app ${pkgdir}/usr/lib/${pkgname}
rm -rf ${pkgdir}/opt
sudo cp -r ${pkgdir}/usr/* /usr/

echo "  -> Moving stuff in place..."
# Launcher
sudo install -Dm755 wechat.sh /usr/bin/${pkgname}

echo "  -> Fixing wechat desktop entry..."
sudo rm /usr/share/applications/weixin.desktop
sudo install -Dm644 ${pkgname}.desktop /usr/share/applications/${pkgname}.desktop

echo "  -> Fixing licenses"
# Move into pkg scoped dir to avoid conflict.
sudo install -m 755 -d /usr/lib/${pkgname}
sudo mv /usr/lib/license /usr/lib/${pkgname}
# Keep soname correct.
sudo chmod 0644 /usr/lib/${pkgname}/license/libuosdevicea.so
sudo install -m 755 -d /usr/lib/license

sudo install -m 755 -d /usr/share/${pkgname}
tar -xzvf license.tar.gz -C "${pkgdir}"
sudo cp -r ${pkgdir}/license/etc /usr/share/${pkgname}
sudo cp -r ${pkgdir}/license/var /usr/share/${pkgname}

rm -rf $pkgdir
rm *.tar.xz debian-binary sign

# use system scrot
cd /usr/lib/wechat-uos/packages/main/dist/
sudo sed -i 's|__dirname,"bin","scrot"|"/usr/bin/"|g' index.js
sudo rm -rf bin

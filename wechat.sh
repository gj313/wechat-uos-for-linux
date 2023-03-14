#!/usr/bin/sh
wechat_pid=`pidof wechat-uos`
if test  $wechat_pid ;then
    kill -9 $wechat_pid
fi
bwrap --dev-bind / / \
    --bind /usr/lib/wechat-uos/license/ /usr/lib/license/ \
    --bind /usr/share/wechat-uos/var/ /var/ \
    electron19 /usr/lib/wechat-uos "$@"

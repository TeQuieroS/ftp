{\rtf1\ansi\ansicpg936\cocoartf2632
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
#
\f1 \'b4\'cb\'bd\'c5\'b1\'be\'c4\'bf\'c7\'b0\'d6\'bb\'ca\'c7\'ce\'aa\'c1\'cb\'b7\'bd\'b1\'e3
\f0 centos7
\f1 \'cf\'c2\'b0\'b2\'d7\'b0
\f0 vsftp,
\f1 \'c6\'e4\'cb\'fb\'b0\'e6\'b1\'be\'ba\'f3\'c6\'da\'bc\'af\'b3\'c9\'a1\'a3
\f0 \
#ftp
\f1 \'ca\'fd\'be\'dd\'b4\'e6\'b7\'c5\'c4\'bf\'c2\'bc
\f0 \
# by liwentong 20191219\
ftp_data=/home/ftp\
check_friewalld()\{\
    echo "
\f1 \'bf\'aa\'ca\'bc\'bc\'ec\'b2\'e9\'b7\'c0\'bb\'f0\'c7\'bd\'c9\'e8\'d6\'c3
\f0 "\
    systemctl status firewalld |grep runing & >/dev/null\
    if [ $? -ne 0 ]\
    then\
        firewall-cmd --add-port=21/tcp --zone=public --permanent\
        firewall-cmd --add-service=ftp\
        firewall-cmd --reload\
    fi\
    if [ $? -eq 0 ]\
    then\
        echo "
\f1 \'b7\'c0\'bb\'f0\'c7\'bd\'bf\'aa\'c6\'f4\'b3\'c9\'b9\'a6
\f0 "\
    fi\
    useradd -s /sbin/nologin ftp\
\}\
#
\f1 \'b4\'ee\'bd\'a8
\f0 ftp\
install_vsftp()\{\
    echo "
\f1 \'bf\'aa\'ca\'bc\'b0\'b2\'d7\'b0
\f0 vsftp 
\f1 \'b2\'a2\'c7\'d2\'bc\'ec\'b2\'e9\'bb\'b7\'be\'b3
\f0 " \
    yum -y install vsftpd libdb-utils\
    if [ $? -ne 0 ]\
    then\
        echo "
\f1 \'c7\'eb\'bc\'ec\'b2\'e9\'c4\'e3\'b5\'c4
\f0 yum
\f1 \'d4\'b4\'c7\'e9\'bf\'f6\'a3\'ac\'ca\'c7\'b7\'f1\'b3\'f6\'cf\'d6\'ce\'de\'b7\'a8\'d3\'c3\'a3\'ac\'bf\'c9\'b5\'a5\'b6\'c0\'d4\'da\'d6\'d5\'b6\'cb\'d6\'b4\'d0\'d0
\f0  yum makecache 
\f1 \'b2\'e2\'ca\'d4
\f0 "\
        exit 1\
    fi\
    #
\f1 \'bc\'ec\'b2\'e9\'b7\'c0\'bb\'f0\'c7\'bd
\f0 ,
\f1 \'bf\'aa\'b7\'c5
\f0 21
\f1 \'b6\'cb\'bf\'da
\f0 \
    check_friewalld\
    echo "
\f1 \'bf\'aa\'ca\'bc\'c5\'e4\'d6\'c3
\f0 ftp"\
    mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf_bak\
    #
\f1 \'c5\'e4\'d6\'c3\'ca\'fd\'be\'dd\'d0\'b4\'c8\'eb\'b5\'bd\'c5\'e4\'d6\'c3\'ce\'c4\'bc\'fe
\f0 \
\
    cat >/etc/vsftpd/vsftpd.conf<<LWT\
listen=yes\
anonymous_enable=no\
dirmessage_enable=YES\
xferlog_enable=YES\
xferlog_file=/var/log/vsftpd.log\
xferlog_std_format=YES\
chroot_list_enable=YES\
chroot_list_file=/etc/vsftpd/chroot_list\
chroot_local_user=yes\
guest_enable=YES\
guest_username=ftp\
user_config_dir=/etc/vsftpd/vsftpd_user_conf\
pam_service_name=vsftpd.vu\
allow_writeable_chroot=YES\
local_enable=YES\
LWT\
\
    read -p "
\f1 \'ca\'e4\'c8\'eb
\f0 ftp
\f1 \'d3\'c3\'bb\'a7
\f0 :" ftp_user\
    if [ ! -n "$ftp_user" ];then\
        ftp_user=test\
    fi\
    read -p "
\f1 \'ca\'e4\'c8\'eb
\f0 ftp
\f1 \'d3\'c3\'bb\'a7\'c3\'dc\'c2\'eb
\f0 :" ftp_passwd\
    if [ ! -n "$ftp_passwd" ];then\
        ftp_passwd=123456\
    fi\
    cd /etc/vsftpd\
    echo $ftp_user >/etc/vsftpd/user.txt\
    echo $ftp_passwd >>/etc/vsftpd/user.txt\
    db_load -T -t hash -f user.txt vsftpd_login.db\
    chmod 600 /etc/vsftpd/vsftpd_login.db\
    touch /etc/pam.d/vsftpd.vu\
    echo "
\f1 \'c5\'d0\'b6\'cf\'b4\'cb\'cf\'b5\'cd\'b3\'ca\'c7
\f0 32
\f1 \'ce\'bb\'b2\'d9\'d7\'f7\'cf\'b5\'cd\'b3\'bb\'b9\'ca\'c7
\f0 64
\f1 \'ce\'bb
\f0 "\
    #
\f1 \'c5\'d0\'b6\'cf
\f0 centos
\f1 \'cf\'b5\'cd\'b3\'ce\'bb
\f0 64
\f1 \'ce\'bb\'bb\'b9\'ca\'c7
\f0 32
\f1 \'ce\'bb
\f0 \
    xd=`getconf LONG_BIT`\
    if [ $xd  -eq '64' ];then\
        echo "
\f1 \'b4\'cb\'cf\'b5\'cd\'b3\'ce\'aa
\f0 64
\f1 \'ce\'bb
\f0 "\
        echo "auth required /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login" >  /etc/pam.d/vsftpd.vu\
        echo "account required /lib64/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login" >> /etc/pam.d/vsftpd.vu\
    else\
        echo "auth required /lib/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login" > /etc/pam.d/vsftpd.vu\
        echo "account required /lib/security/pam_userdb.so db=/etc/vsftpd/vsftpd_login" >> /etc/pam.d/vsftpd.vu\
    fi\
    #
\f1 \'cf\'de\'d6\'c6\'d3\'c3\'bb\'a7\'c7\'d0\'bb\'bb\'b9\'a4\'d7\'f7\'c4\'bf\'c2\'bc
\f0 \
    touch /etc/vsftpd/chroot_list\
    echo $ftp_user >>/etc/vsftpd/chroot_list\
    #
\f1 \'c5\'e4\'d6\'c3\'d0\'e9\'c4\'e2\'d3\'c3\'bb\'a7\'b5\'c4\'c5\'e4\'d6\'c3\'ce\'c4\'bc\'fe
\f0 \
    mkdir -p /etc/vsftpd/vsftpd_user_conf\
    cd /etc/vsftpd/vsftpd_user_conf\
    #
\f1 \'d0\'b4\'c8\'eb\'d3\'c3\'bb\'a7\'c8\'a8\'cf\'de\'c5\'e4\'d6\'c3
\f0 \
    cat >$ftp_user <<LWT\
write_enable=YES\
anon_world_readable_only=NO\
anon_upload_enable=YES\
anon_mkdir_write_enable=YES\
anon_other_write_enable=YES\
LWT\
    echo "local_root="$ftp_data/$ftp_user>>$ftp_user\
    mkdir -p $ftp_data\
    chown -R ftp:root $ftp_data\
    chmod o+rw $ftp_data\
    mkdir -p $ftp_data/$ftp_user\
    chmod -R 777 $ftp_data/$ftp_user\
    systemctl restart vsftpd.service\
\}\
#
\f1 \'b4\'b4\'bd\'a8\'d0\'e9\'c4\'e2\'d3\'c3\'bb\'a7
\f0 \
create_user()\{\
    ftp_passwd=123456\
    read -p "
\f1 \'ca\'e4\'c8\'eb\'c4\'e3\'d2\'aa\'b4\'b4\'bd\'a8\'b5\'c4\'d3\'c3\'bb\'a7\'c3\'fb
\f0 :" ftp_user\
    if [ ! -n  "$ftp_user" ];then\
        echo "
\f1 \'c4\'e3\'c3\'bb\'d3\'d0\'ca\'e4\'c8\'eb\'d3\'c3\'bb\'a7\'c3\'fb
\f0 ,
\f1 \'cd\'cb\'b3\'f6
\f0 "\
        exit 1\
    else\
        read -p "
\f1 \'ca\'e4\'c8\'eb\'c3\'dc\'c2\'eb
\f0 :" ftp_pass\
        if [ ! -n "$ftp_pass" ];then\
            echo "
\f1 \'c3\'dc\'c2\'eb\'c3\'bb\'d3\'d0\'ca\'e4\'c8\'eb
\f0 ,
\f1 \'c4\'ac\'c8\'cf
\f0 123456"\
        else\
            ftp_passwd=$ftp_pass\
        fi\
    fi\
    cd /etc/vsftpd\
    echo $ftp_user >>/etc/vsftpd/user.txt\
    echo $ftp_passwd >>/etc/vsftpd/user.txt\
    db_load -T -t hash -f user.txt /etc/vsftpd/vsftpd_login.db\
    chmod 600 /etc/vsftpd/vsftpd_login.db\
    echo $ftp_user >>/etc/vsftpd/chroot_list\
    cd /etc/vsftpd/vsftpd_user_conf\
    cat >$ftp_user<<LWT \
write_enable=YES\
anon_world_readable_only=NO\
anon_upload_enable=YES\
anon_mkdir_write_enable=YES\
anon_other_write_enable=YES\
LWT\
    echo "local_root="$ftp_data/$ftp_user>>$ftp_user\
    mkdir -p $ftp_data/$ftp_user\
    chmod -R 777 $ftp_data/$ftp_user\
\}\
\
\
echo "
\f1 \'ca\'e4\'c8\'eb\'c4\'e3\'d2\'aa\'b2\'d9\'d7\'f7\'b5\'c4\'c4\'da\'c8\'dd
\f0 "\
select var in install_vsftpd create_user quit\
do\
    \
    case $var in \
    install_vsftpd)\
        install_vsftp;\
        ;;\
    create_user)\
        create_user\
        ;;\
    quit)\
        exit 1\
        ;;\
    esac\
done\
\
}
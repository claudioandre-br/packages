#!/bin/bash

function do_help(){
    echo 'Usage: ./buggy.sh enable/disable'
    echo
    echo 'enable:       move all buggy formats back to JtR main directory, so they are going to be built.'
    echo 'disable:      disable all "buggy" formats, moving them to a subfolder named bugged.'
    echo

    exit 0
}

if [[ $# -eq 0 ]]; then
    do_help
fi

CL=

#bcrypt BF_fmt.c
FILES="pbkdf2-hmac-md4_fmt_plug.c pbkdf2-hmac-md5_fmt_plug.c $CL/opencl_pbkdf2_hmac_md4_fmt_plug.c \
       $CL/opencl_pbkdf2_hmac_md5_fmt_plug.c $CL/opencl_bf_fmt_plug.c $CL/opencl_DES_fmt_plug.c \
       $CL/opencl_DES_bs* $CL/opencl_gpg_fmt_plug.c $CL/opencl_krb5pa-md5_fmt_plug.c \
       $CL/opencl_mscash2_fmt_plug.c $CL/opencl_nt_fmt_plug.c $CL/opencl_ntlmv2_fmt_plug.c \
       $CL/opencl_o5logon_fmt_plug.c $CL/opencl_rawmd5_fmt_plug.c $CL/opencl_rawmd4_fmt_plug.c \
       $CL/opencl_xsha512_fmt_plug.c $CL/opencl_mysqlsha1_fmt_plug.c $CL/opencl_mscash_fmt_plug.c \
       openbsdsoftraid_fmt_plug.c dpapimk_fmt_plug.c $CL/opencl_sl3_fmt_plug.c \
       $CL/opencl_rawsha1_fmt_plug.c $CL/opencl_salted_sha_fmt_plug.c $CL/opencl_bitlocker_fmt_plug.c \
       mscash2_fmt_plug.c $CL/opencl_keepass_fmt_plug.c monero_fmt_plug.c iwork_fmt_plug.c ethereum_fmt_plug.c \
       dmg_fmt_plug.c adxcrypt_fmt_plug.c rawBLAKE2_512_fmt_plug.c encfs_fmt_plug.c gpg_fmt_plug.c \
       $CL/opencl_encfs_fmt_plug.c $CL/opencl_wpapsk_fmt_plug.c $CL/src/opencl_wpapmk_fmt_plug.c \
       racf_kdfaes_fmt_plug.c HDAA_fmt_plug.c"

#BCrypt
patch -l -f -p1 <<ENDPATCH
diff --git a/src/john.c b/src/john.c
index 285ce89..219edbe 100644
--- a/src/john.c
+++ b/src/john.c
@@ -362,7 +362,7 @@ static void john_register_all(void)
 	john_register_one(&fmt_DES);
 	john_register_one(&fmt_BSDI);
 	john_register_one(&fmt_MD5);
-	john_register_one(&fmt_BF);
+	//john_register_one(&fmt_BF);
 	john_register_one(&fmt_scrypt);
 	john_register_one(&fmt_LM);
 	john_register_one(&fmt_AFS);
ENDPATCH
# -----

Total_Formats=0

case "$1" in
    "enable" | "--enable" | "-e")
        echo "Please, stash. You can't enable the formats.";;
    "disable" | "--disable" | "-d")
        for i in $FILES ; do rm -f src/$i ; Total_Formats=$((Total_Formats + 1)); done;;
    *)
        do_help;;
esac
echo "All $Total_Formats formats were moved in $SECONDS seconds."

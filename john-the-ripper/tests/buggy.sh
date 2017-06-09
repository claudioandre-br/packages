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

#bcrypt BF_fmt.c
FILES="pbkdf2-hmac-md4_fmt_plug.c pbkdf2-hmac-md5_fmt_plug.c opencl_pbkdf2_hmac_md4_fmt_plug.c opencl_pbkdf2_hmac_md5_fmt_plug.c opencl_bf_fmt_plug.c opencl_DES_fmt_plug.c opencl_DES_bs*  opencl_gpg_fmt_plug.c opencl_krb5pa-md5_fmt_plug.c opencl_mscash2_fmt_plug.c opencl_nt_fmt_plug.c opencl_ntlmv2_fmt_plug.c opencl_o5logon_fmt_plug.c opencl_rawmd5_fmt_plug.c opencl_rawmd4_fmt_plug.c opencl_xsha512_fmt_plug.c opencl_mysqlsha1_fmt_plug.c opencl_mscash_fmt_plug.c openbsdsoftraid_fmt_plug.c dpapimk_fmt_plug.c opencl_sl3_fmt_plug.c"

#BCrypt
patch -l -f -p2 <<ENDPATCH
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

mkdir -p bugged
Total_Formats=0

case "$1" in
    "enable" | "--enable" | "-e")
        for i in $FILES ; do mv -f bugged/$i . ; Total_Formats=$((Total_Formats + 1)); done;;
    "disable" | "--disable" | "-d")
        for i in $FILES ; do mv -f $i bugged/ ; Total_Formats=$((Total_Formats + 1)); done;;
    *)
        do_help;;
esac
echo "All $Total_Formats formats were moved in $SECONDS seconds."

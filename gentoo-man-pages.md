# Making man pages usable after switching from man-db to mandoc on Gentoo

The [Mandoc page of the Gentoo wiki](https://wiki.gentoo.org/wiki/Mandoc) notes:

> During installation, man pages are compressed using the value of the PORTAGE_COMPRESS variable, which by default is "bzip2". However, mandoc does not handle bzip2'd man pages, so after changing this flag, those man pages will no longer be readable.

It goes on to note that one way to address this issue is to re-`emerge` any packages containing man packages. However, this can result in having to re-emerge packages with substantial compile times, such as `llvm`.

Another way to address this issue, albeit one that will result in warnings from affected packages the next time they're `emerge`d, is to manually remove the compression from all man pages, and fix the resulting broken symlinks. The following script, [decompress-man-pages.sh](./decompress-man-pages.sh), automates this process, and should work with any POSIX-compliant shell. **Use at your own risk!** The script has deliberately not been added to the Gentoo wiki, in order to try to reduce the risk of people accidentally breaking their man system.

```
#!/bin/sh

descend () {

    for SUBDIR in $(find . -maxdepth 1 -type d | grep -vE '^\.$|^\./\.')
    do
        cd $SUBDIR
        echo "  SUBDIR: $PWD"
        if $(basename "$PWD" | grep -q '^man.')
        then
            echo "    Decompressing files, fixing symlinks ..."
            decompress_files_and_fix_symlinks
            cd ..
        else
            descend
            cd ..
        fi
    done
    
}

decompress_files_and_fix_symlinks () {

    FILES=$(find . -name '*.bz2')
    if [ -n "$FILES" ] 
    then

        # Decompress files
        for F in $FILES
        do
            if [ ! -L $F ]
            then
                bunzip2 $F
            fi
        done
        
        # Fix symlinks
        LINKS=$(find . -type l)
        if [ -n "$LINKS" ]
        then
            for LINK in $(ls -l *.bz2 | awk -e '{ OFS=":"; print $11, $9 }')
            do
                BZ2_TARGET=$(echo $LINK | awk -F ':' '{ print $1 }')
                BZ2_LINK_NAME=$(echo $LINK | awk -F ':' '{ print $2 }')
                ln -sf ${BZ2_TARGET%%.bz2} ${BZ2_LINK_NAME%%.bz2}
                rm $BZ2_LINK_NAME
            done
        fi
    fi

}

for MANDIR in "/tmp/test"
#              $(echo $MANPATH | tr ':' ' ')
do
    if [ -d $MANDIR ]
    then
        cd $MANDIR
        echo "MANDIR: $PWD"
        descend
    fi
done

exit 0

```


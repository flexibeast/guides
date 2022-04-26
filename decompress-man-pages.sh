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

for MANDIR in $(echo $MANPATH | tr ':' ' ')
do
    if [ -d $MANDIR ]
    then
        cd $MANDIR
        echo "MANDIR: $PWD"
        descend
    fi
done

exit 0

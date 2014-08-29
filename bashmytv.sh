#!/bin/bash
# unaquired feed
UNAQRSS='http://www.myepisodes.com/rss.php?feed=unacquired&showignored=0&uid=xxx&pwdmd5=xxx'
# unwatched feed
UNWARSS='http://www.myepisodes.com/rss.php?feed=unwatched&showignored=0&uid=xxx&pwdmd5=xxx'

UNQ=$(curl -s $UNAQRSS | grep '<title>\[' | sed -e 's/<[^>]\+>//g' -e 's/^[ \t]*//' -e 's/\]\[/-/g' -e 's/\[\ //g' -e 's/\ \]//g')
UNW=$(curl -s $UNWARSS | grep '<title>\[' | sed -e 's/<[^>]\+>//g' -e 's/^[ \t]*//' -e 's/\]\[/-/g' -e 's/\[\ //g' -e 's/\ \]//g')

if [[ -z "$UNQ" ]] || [[ -z "$UNW" ]]; then
    echo "Something went wrong, maybe the feed address is wrong? Try running both this commands:"
    echo
    echo -e "\t curl '$UNAQRSS'"
    echo -e "\t curl '$UNWARSS'"
    echo
    echo "both should generate output."
    exit 1
fi

UNQNO=$(echo "$UNQ"|wc -l)
UNWNO=$(echo "$UNW"|wc -l)

if [ "$UNWNO" = "200" ]; then UNWNO="200+"; fi		# myepisodes.com limts this feed to 200 items

echo "$UNQNO episode$([ "$UNQNO" = "1" ] && echo " needs" || echo "s need") to be aquired:"
echo "$UNQ"
echo

echo "$UNWNO episode$([ "$UNWNO" != "1" ] && echo "s") to watch"
echo "$UNW"

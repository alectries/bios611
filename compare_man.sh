echo man, $(man man | wc -l) >> ./.compare_man
echo ls, $(man ls | wc -l) >> ./.compare_man
echo find, $(man find | wc -l) >> ./.compare_man
cat ./.compare_man | sort -g -k 2 -r -t ,
rm -f ./.compare_man
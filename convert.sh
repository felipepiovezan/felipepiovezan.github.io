set -eou pipefail
#set -x

# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526#54561526
readarray -d '' md_files < <(find . -name "*.md" -print0)

for md_file in ${md_files[@]}; do
  dir_name=$(dirname $md_file)
  markdown -o $dir_name/index.html $md_file
done

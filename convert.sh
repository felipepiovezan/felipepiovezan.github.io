set -eou pipefail
# set -x

readarray -d '' md_files < <(find . -name "*.md" -print0)

highlight_style="--highlight-style=$PWD/templates/solarized.theme"

# https://pandoc.org/MANUAL.html#variables-for-html
css="--variable=fontcolor:white --variable=backgroundcolor:black"
css=""

pandoc_flags="-f markdown -t html -s
              --fail-if-warnings
              --self-contained
              ${css} ${highlight_style}"

for md_path in ${md_files[@]}; do
  dir_name=$(dirname $md_path)
  md_name=$(basename $md_path)

  (cd ${dir_name} &&
   pandoc ${pandoc_flags} ${md_name} -o index.html)
done
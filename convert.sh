set -eou pipefail
# set -x

readarray -d '' md_files < <(find . -name "*.md" -print0)

highlight_style="--highlight-style=$PWD/templates/solarized.theme"
table_of_contents="--toc --include-in-header=$PWD/templates/toc.css "

# https://pandoc.org/MANUAL.html#variables-for-html
css="--variable=fontcolor:white --variable=backgroundcolor:black"
css=""

add_home_buttom="--include-in-header=$PWD/templates/top_bar.css
                 --include-before-body=$PWD/templates/blog_home_link.html"

pandoc_flags="-f markdown -t html -s
              --fail-if-warnings
              --self-contained
              ${table_of_contents}
              ${css}
              ${highlight_style}
              ${add_home_buttom}"

# Returns "--include-in-header=header.html" if the file exists in `md_dir`.
get_header_flag() {
  md_dir=$1
  header_name="header.html"
  header_path=${md_dir}/${header_name}
  if test -f "${header_path}"; then
      echo "--include-in-header=${header_name}"
  fi
  echo ""
}

for md_path in ${md_files[@]}; do
  dir_name=$(dirname $md_path)
  md_name=$(basename $md_path)
  header_flag="$(get_header_flag ${dir_name})"

  (cd ${dir_name} &&
   pandoc ${pandoc_flags} ${header_flag} ${md_name} -o index.html)
done

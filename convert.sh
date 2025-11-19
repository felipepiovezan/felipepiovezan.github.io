set -xeou pipefail

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

md_files=($(find . -name "*.md"))
for md_path in ${md_files[@]}; do
  dir_name=$(dirname $md_path)
  header_flag="$(get_header_flag ${dir_name})"

  pandoc --resource-path=${dir_name} \
         --defaults defaults.yaml \
         ${header_flag} \
         ${md_path} \
         -o ${dir_name}/index.html
done

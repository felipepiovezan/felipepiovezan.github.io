set -eou pipefail
set -x

no_changes() {
  any_diff=$(git status --porcelain)
  echo $any_diff
  [ -z "$any_diff" ]
}

no_changes
git checkout deploy
git reset --hard  main
./convert.sh
git add . --force
git commit -m "auto-deploy"
git push --force
git checkout main

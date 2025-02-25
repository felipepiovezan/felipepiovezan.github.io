
# Get the most value out of reviewers. 

Reviewers are the best resource to stop bad or buggy code from being merged,
and PR authors can do a lot to push reviewers in the right direction. In
particular, asking the question: "will this diff make reviewers spend time where it
is unimportant?". If the answer is yes, it's better to get rid of it.

A common example: unrelated diffs. This is commonly employed to fix small
issues -- like a typo or a using a modern construct in place of an old one --
where "it would more to work to do it separately". Do it separately. Laziness
is bad excuse. But there is an objective reason: if a patch needs to be
reverted, these unrelated changes would be reverted as well.

# Review before the review.

Self-review PRs before requesting review from others. Often, looking at the
code in a different environment -- be it `git diff` or Github's PR interface --
is enough to spot the most basic kinds of mistakes:

* I forgot to remove this TODO.
* I forgot to add a comment on this function.
* I forgot to commit the new file containing tests.
* I forgot to write a commit message.
* This comment does not make sense.
* This is not according to the coding style.
* I forgot to remove diffs unrelated to the patch.

Or many other mistakes like this. The best use of code review is to spot
correctness issues in the code; leaving any of the above in the first iteration
will slow, if not prevent, the process of catching mistakes. It may also make
reviewers see the author negatively.

# Employ NFC patches liberally.

# Integrate formatters into development tools.

Good projects have a hard check during code review against code that is not
formatted according to the projects guidelines, but letting it go that far can
be detrimental. For example, when working with stacked patches, an incorrectly
formatted patch early in the series can take long to fix. As such, integrating
formatters and tooling can save time and remove distractions from the act of
coding.

A text editor should be configured with the ability to format both an entire
file as well as text blocks; the latter is important because many projects are
not 100% formatted correctly, and unnecessary diffs in should not be
introduced.

Integration with Git is possible in many ways. With C++, `git-clang-format`
allows formatting all staged changes. Pre-commit hooks can be used to emit
warnings when committing code that is not formatted properly, with errors being
a possibility but often getting in the way of work-in-progress commits.

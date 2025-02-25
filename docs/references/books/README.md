---
title: Technical Books
---

A work-in-progress list of books with random thoughts on them. This is here
mostly for my own reference, but hey! :)

# Writing

## Elements of Style

This book provides very pragmatic advice to writing, both in terms of grammar
advice as well as in matters of form and style. It is a book I see myself
revisiting from time to time, followed by an editorial reread of anything I've
written here. More importantly, nearly all advice in the book can be applied to
technical writing one does in PRs or slack, where the goal is to be precise and
to the point.

In a few occasions, the advice is very opinionated, with the author expressing
dislike for words or expressions without giving much justification; these are
in the minority and you can take or ignore said advice. I mention them for two
reasons. One is the irony this creates with an advice in the concluding
chapter, where the author prescribes separation of facts from opinions,
suggesting authors should be explicit about which one is which. The other
reason is that, looking back at my earlier attempts at writing, I would let
much opinion and frustration slip into the text, making the text
more human and somewhat fun to read, but distracting from my goal of _teaching_
and from the points I was trying to get across. The first draft of my build
systems piece was written at a time where I was livid with the build system
used in my job; as a result, the text was full of snarky remarks, or bold
claims like "an incorrect way to build is ...", a "decent build system...".

The important lessons I try to carry with me are:

* Don't be vague.
* Say what you mean, exactly that and nothing more.
* Separate fact from opinion.
* If there is ambiguity, get rid of it even if one of the alternatives is
  ridiculous, it distracts the reader.

There are matters of form and grammar that I must work on; for example, re-use
of the same few sentence structures. A good writer does not distract the reader
by employing the same kinds of sentences repeatedly, I'm sure I do.


# Programming Languages:

## The Little Typer

An informal introduction on how to use type systems as a proof mechanism. As a
first approach to the subject, the first two thirds of the book were very
enjoyable; the book is written as a dialogue, in the style of Plato, which made
it easy to read. That said, the informal approach made it hard to follow the
final, more complicated, examples where there is a lot to keep track of.

This was my first exposure to Lisp-like languages, it was particularly nice to
see how mathematical induction was used within the toy language to avoid loops
and infinite recursion. In hindsight, it might have been smarter to start with
"The Little Schemer" so that only the concepts related to type theory were new.

A good follow-up book is likely "Types and programming languages", which is a
much more formal book on the topic. It is on the "To Read" list below.

## Category Theory for Programmers

Category Theory is another mathematical area that has a lot of overlap with
programming, and this book takes a very informal approach to explaining the
related concepts. I recall being bothered by this, as there weren't a lot of
precise definitions; instead, a lot of Haskell programs were used. I think the
text suffered as a result, but I am biased towards the more mathematical,
precise way of defining things. I ended up dropping the book around the mid
point, but still managed to learn a lot with it.

# Debugging:

## The Architecture of Open Source Applications - GDB

This goes over a high level overview of what a debugger needs to in order to
debug programs. It talks about breakpoints, symbols and symbol tables, stack
frames, expressions, values, targets, the execution control main loop, the
remote protocol, and GDBserver.

Free book available at: <http://aosabook.org/en/gdb.html>.

# To Read:

1. The next 700 programming languages paper
2. Crafting interpreters
3. Types and programming languages
4. Elements of programming
5. Seven languages in seven days
6. Considered harmful considered harmful

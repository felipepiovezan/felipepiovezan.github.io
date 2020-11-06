---
title: Topological sorting - ACM-ICPC
slug: ../improve_spam
---

The [2019 ACM-ICPC Latin
American](http://cfrp.azurewebsites.net/blog/entry/71296) contest took place
this November and it is a great source of cleverly designed algorithm problems.
This contest is not to be taken lightly; the problems are challenging and there
is no shame in admiting that I can solve very few of them on my own.

That said, I will give them a try, starting with the (arguably) easiest problem
of the contest.

## Prerequisites

This problem is about graphs, depth first search, topological sorting and
basic dynamic programming.

## Improve spam !

The full problem description can be found on [page 14 of the contest
handout](https://codeforces.com/gym/102428/attachments/download/9820/statements-en.pdf).
Let's read together an abridged version of the problem statement:

## Problem statement

We're told that an email server processes emails with the following properties:

* An email address either refers to a mailing list or to a client.
* A mailing list `L` is defined by a list of email addresses: `L(1), L(2), ...`.
* When an email is sent to a mailing list `L`, the server processes each email address
`L(i)` contained in the list:
  * If `L(i)` is a client, an email is sent to `L(i)`.
  * If `L(i)` is a mailing list, the server processes each email in `L(i)`.

Given a server configuration, i.e. a list of emails plus a description of
mailing lists and client emails, and given that an email is sent to address
`Addr`, we're tasked with computing:

1. The number of emails that are sent to clients.
2. The number unique clients that receive an email.

## A suitable abstraction

The problem description lends itself very nicely to a directed graph
representation:

1. Vertices are email addresses (Lists and Clients).

2. Edges are always of the form `List x -> Email y`, denoting the fact that
`List x` contains `Email y`.

Note that the source node of an edge is always a list address; put differently,
vertices corresponding to client addresses are always leaves in this graph.

## An example

Consider the following scenario:

![example 1](ex_1.png)

If we send an email to `List 1`:

* `Client 5` gets two emails:
  * One from the path `List 1 -> List 2 -> Client 5 `.
  * One from the path `List 1 -> List 3 -> List 2 -> Client 5`.
* `Client 4` gets three emails:
  * One from the path `List 1 -> List 2-> Client 4`.
  * One from the path `List 1 -> List 3 -> List 2 -> Client 4`.
  * One from the path `List 1 -> List 3 -> Client 4`.

In this example, the answer would be:
  * 5 emails are sent to clients.
  * 2 unique clients receive emails.

## Infinite emails?

You might be wondering:

> What if `List 1` sends an email to `List 2`, and `List 2`
sends an email to `List 1`? That will cause an infinite number of emails to be
sent!

In other words, what if there is a cycle in the graph?

The problem statement contains the following:

> [...] only when a mailing list is created it can be added to any number of
> existing mailing lists

This is a hint to the fact that it is impossible to have a cycle in the graph
defined by the mailing lists! Convince yourself of this fact before proceeding,
or better yet, prove it:

Suppose there is a cycle `List 1 -> List 2 -> List 1`:

1. The edge `List 1 -> List 2` implies that `List 1` was created after `List 2`.
2. The edge `List 2 -> List 1` implies that `List 2` was created after `List 1`.

This forms a contradiction, so the cycle cannot exist. With induction on the
cycle length, you can generalize this proof.

The conclusion: we are working on a Directed Acyclic Graph (DAG).

## The naive solution

Simulate the whole email-sending process: traverse the graph, starting from
address `Addr`, visiting all adjacent nodes to the node being visited.
Whenever we visit a vertex corresponding to a client address, we increment a
counter of emails sent.

Note that we might visit some nodes multiple times, as the previous example
shows. Howeveer, our traversal is guaranteed to finish because the graph is
acyclic.

How efficient is this solution? The number of operations is linear in the
number of times vertices are visited. Note: it is NOT linear in the number of
vertices or edges in the graph, but on the number of times we visit vertices.

The problem statement is trying to tell us that this approach is bound to
fail:

>  Because  these  numbers  can  be  very  large,  output  the  remainder  of
>  dividing them by 10^9 + 7.

In other words, the number of times we visit vertices is so big that it doesn't
fit on a 32 bit integer. Can you come up with some graphs that showcase how
spammy those emails can be?

Our naive solution is bound to be extremely slow and will receive a Time Limit
Exceeded answer from the contest judge.

## A better solution

Notational convenience: `total(Address x)` denotes the total number of emails
sent to clients if we send an email to `Address x`.

We're trying to compute `total(Addr)`. If we know this value for all
successors of `Addr` in the graph, then `total(Addr)` is simply the sum of
all those values.

Let's consider our previous example, where we're trying to compute the answer
when `List 1` gets the initial email:

![example 1](ex_1.png)

1. `total(Client 5) = 1`, sending an email to a client only causes one client
to receive an email.
2. `total(Client 4) = 1`, similarly.

We can now compute `total(List 2)`:

3. `total(List 2) = total(Client 5) + total(Client 4) = 1 + 1 = 2`.

Similarly for `total(List 3)`:

4. `total(List 3) = total(List 2) + total(Client 4) = 2 + 1 = 3`.

Similarly for `total(List 1)`:

5. `total(List 1) = total(List 2) + total(List 3) = 2 + 3 = 5`.

And that's the answer we are looking for! If we have an array of vertices in
some apropriate order, what we are doing above is a simple case of dynamic
programming.

How do we obtain this apropriate order? The key is to exploit properties of
DAGs; in particular, we want to visit only nodes whose successors have all been
visited. This is known as a [topological order] and it is guaranteed to exist
for DAGs[^1].

## Topological sorting

One way to obtain a topological order is with a Depth First Search.
Here's a C++ implementation[^2]:

```cpp
void compute_topological_order() {
  visited = std::vector<bool>(num_addresses + 1, false);
  dfs(1);
}
```

```cpp
void dfs(int visiting) {
  visited[visiting] = true;

  for (auto next : successor_vertices[visiting])
    if (!visited[next])
      dfs(next);
  topologic_order.push_back(visiting);
}
```

This captures the idea described previously: visit all successors of a node
first, then add the node itself to the topological order.

## Computing the solution

The number of spammy emails can be computed as follows:

```cpp
auto num_emails = std::vector<uint64_t>(num_addresses + 1, 0);

for (auto node : topologic_order) {
  if (is_client_email(node))
    num_emails[node] = 1;
  else {
    num_emails[node] = std::accumulate(
        std::begin(successor_vertices[node]),
        std::end(successor_vertices[node]),
        uint64_t{0}, // Initial value
        [&](auto sum, auto next) {
          return (sum + num_emails[next]) % 1000000007;
        });
  }
}

spam_emails = num_emails[1];
```

## Conclusion

This was the easiest problem of the contest. I must admit it took me roughly 3
hours to come up with the final, correct implementation. When you consider the
fact that the contest lasts five hours and contains 13 problems, most of which
are harder than this, an inevitable conclusion comes to mind: those competitors
are really good.

Two important mistakes I made:

1. I fell for the trap of the naive solution. Doing a few sketches in paper
would have been enough to prove that this was bound to fail. Also, pay
attention to the problem statement, it's always full of hints about the
solution.
2. I was trying to be clever and avoid a recursive implementation, doing an
iterative implementation of DFS while calculating the number of emails sent at
the same time. This was a mistake - simplicity first, always.

It's always humbling to face problems from this contest, as it reminds you of
how little you know and how much better you can get.

[^1]: Technically, this is the reverse of the topological order.

[^2]: The `visited` vector is initialized with `num_addresses + 1` booleans,
all initially set to false. The `+ 1` is there because the problem input is not
0 based.


## Complete solution

This is the solution that I [submitted on
Codeforces](https://codeforces.com/gym/102428/problem/I):

```cpp
#include <algorithm>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <numeric>
#include <vector>

struct Solver {

  Solver() {
    read_input();
    compute_topological_order();
    compute_solution();
  }

  void read_input() {
    std::cin >> num_addresses >> num_lists;
    successor_vertices.resize(num_addresses + 1);

    for (int i = 1; i <= num_lists; i++) {
      int num_elements;
      std::cin >> num_elements;
      std::copy_n(std::istream_iterator<int>(std::cin), num_elements,
                  std::back_inserter(successor_vertices[i]));
    }
  }

  void compute_topological_order() {
    visited = std::vector<bool>(num_addresses + 1, false);
    dfs(1);
  }

  void dfs(int visiting) {
    visited[visiting] = true;
    for (auto next : successor_vertices[visiting])
      if (!visited[next])
        dfs(next);
    topologic_order.push_back(visiting);
  }

  bool is_client_email(int index) { return index > num_lists; }

  void compute_solution() {
    single_emails =
        std::count_if(std::begin(topologic_order), std::end(topologic_order),
                      [&](auto address) { return is_client_email(address); });

    auto num_emails = std::vector<uint64_t>(num_addresses + 1, 0);

    for (auto node : topologic_order) {
      if (is_client_email(node))
        num_emails[node] = 1;
      else {
        num_emails[node] = std::accumulate(
            std::begin(successor_vertices[node]),
            std::end(successor_vertices[node]), uint64_t{0},
            [&](auto sum, auto next) {
              return (sum + num_emails[next]) % (1000000000 + 7);
            });
      }
    }

    spam_emails = num_emails[1];
  }

  int num_addresses;
  int num_lists;
  std::vector<std::vector<int>> successor_vertices;
  std::vector<int> topologic_order;
  std::vector<bool> visited;

  uint64_t spam_emails;
  uint64_t single_emails;
};

int main() {
  auto ans = Solver{};
  std::cout << ans.spam_emails << " " << ans.single_emails;
  return 0;
}
```

[topological order]: https://en.wikipedia.org/wiki/Topological_sorting

# blockchain.rb

A simple P2P proof-of-work blockchain in Ruby

![Rspec](https://github.com/gervaiscodes/blockchain.rb/actions/workflows/rspec.yaml/badge.svg) ![Rubocop](https://github.com/gervaiscodes/blockchain.rb/actions/workflows/rubocop.yaml/badge.svg)

## How to use

1. Start 3 nodes

```
$ rackup -p 9292 > /dev/null 2>&1 &
$ rackup -p 9293 > /dev/null 2>&1 &
$ rackup -p 9294 > /dev/null 2>&1 &
```

```
$ jobs
[1]    running    rackup -p 9292 > /dev/null 2>&1
[2]  - running    rackup -p 9293 > /dev/null 2>&1
[3]  + running    rackup -p 9294 > /dev/null 2>&1
```

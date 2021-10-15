# blockchain.rb

A simple P2P proof-of-work blockchain in Ruby

![Rspec](https://github.com/gervaiscodes/blockchain.rb/actions/workflows/rspec.yaml/badge.svg) ![Rubocop](https://github.com/gervaiscodes/blockchain.rb/actions/workflows/rubocop.yaml/badge.svg)

## How to use

1. Start 3 nodes:

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

```
$ curl http://127.0.0.1:9292/blocks
[{"index":0,"timestamp":1634283592,"nonce":0,"previous_hash":"","hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","data":"Genesis Block"}]

$ curl http://127.0.0.1:9293/blocks
[{"index":0,"timestamp":1634283644,"nonce":0,"previous_hash":"","hash":"705abdeadc164196206173571a003567b9874075002f92be04c424b67eb3aa7f","data":"Genesis Block"}]

$ curl http://127.0.0.1:9294/blocks
[{"index":0,"timestamp":1634283650,"nonce":0,"previous_hash":"","hash":"9183b8c282aef6995a95c92131f4b8cb7a471e590dbfda9146e913362e5a13b0","data":"Genesis Block"}]
```

2. Connect nodes together:

```
$ curl -X POST -H "Accept: application/json" -H 'Content-Type: application/json' \
  -d '{"urls": ["http://127.0.0.1:9293", "http://127.0.0.1:9294"]}' http://127.0.0.1:9292/add_peers

$ curl -X POST -H "Accept: application/json" -H 'Content-Type: application/json' \
  -d '{"urls": ["http://127.0.0.1:9292", "http://127.0.0.1:9294"]}' http://127.0.0.1:9293/add_peers

$ curl -X POST -H "Accept: application/json" -H 'Content-Type: application/json' \
  -d '{"urls": ["http://127.0.0.1:9292", "http://127.0.0.1:9293"]}' http://127.0.0.1:9294/add_peers
```

3. Mine a block on the first node with some data:

```
$ curl -X POST -H "Accept: application/json" -H 'Content-Type: application/json' \
  -d '{"data": "SOME DATA"}' http://127.0.0.1:9292/mine
```

All the nodes are now in sync with the same chain:

```
$ curl http://127.0.0.1:9292/blocks
[{"index":0,"timestamp":1634283592,"nonce":0,"previous_hash":"","hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","data":"Genesis Block"},{"index":1,"timestamp":1634283914,"nonce":10736,"previous_hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","hash":"0000e0f7cd443aa54737946a2b8210193b9ec36cdfcf5ae63c99d3f41d89a15f","data":"SOME DATA"}]

$ curl http://127.0.0.1:9293/blocks
[{"index":0,"timestamp":1634283592,"nonce":0,"previous_hash":"","hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","data":"Genesis Block"},{"index":1,"timestamp":1634283914,"nonce":10736,"previous_hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","hash":"0000e0f7cd443aa54737946a2b8210193b9ec36cdfcf5ae63c99d3f41d89a15f","data":"SOME DATA"}]

$ curl http://127.0.0.1:9294/blocks
[{"index":0,"timestamp":1634283592,"nonce":0,"previous_hash":"","hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","data":"Genesis Block"},{"index":1,"timestamp":1634283914,"nonce":10736,"previous_hash":"6d80a36d1af2f4c6ab5eb7f0b63f8c64d6d0050bb50e32a17605198a7c7f0eac","hash":"0000e0f7cd443aa54737946a2b8210193b9ec36cdfcf5ae63c99d3f41d89a15f","data":"SOME DATA"}]
```

/*

Copyright 2017 The Wallaroo Authors.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 implied. See the License for the specific language governing
 permissions and limitations under the License.

*/

"""
Setting up a counter-app run (in order):
1) reports sink:
nc -l 127.0.0.1 7002 >> /dev/null

2) metrics sink:
nc -l 127.0.0.1 7003 >> /dev/null

3a) single worker counter app:
./counter-app -i 127.0.0.1:7010 -o 127.0.0.1:7002 -m 127.0.0.1:8000 -c 127.0.0.1:6000 -d 127.0.0.1:6001 -e 10000000 -n worker-name

3b) multi-worker counter-app:
./counter-app -i 127.0.0.1:7010 -o 127.0.0.1:7002 -m 127.0.0.1:8000 -c 127.0.0.1:6000 -d 127.0.0.1:6001 -e 10000000 -w 3 -t -n worker1
./counter-app -i 127.0.0.1:7010 -o 127.0.0.1:7002 -m 127.0.0.1:8000 -c 127.0.0.1:6000 -d 127.0.0.1:6001 -e 10000000 -w 3 -n worker2
./counter-app -i 127.0.0.1:7010 -o 127.0.0.1:7002 -m 127.0.0.1:8000 -c 127.0.0.1:6000 -d 127.0.0.1:6001 -e 10000000 -w 3 -n worker3

Incoming messages:
[size] -- how many bytes to follow, 16-bit big endian
[count] -- how many integers to follow, 16-bit big endian
[value1] -- value 1, 32-bit big endian
...
[valueN] -- value N, 32-bit big endian

Outgoing messages:
[total] -- total count so far, 64-bit big endian

To send a message:

`echo -n '\0\012\0\02\0\0\03\01\0\0\0\03' | nc 127.0.0.1 7010`
"""

use "wallaroo/cpp_api/pony"

use "lib:wallaroo"
use "lib:c++"

use "lib:counter"

actor Main
  new create(env: Env) =>
    WallarooMain(env)

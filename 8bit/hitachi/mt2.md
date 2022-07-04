MT-2 OS V1.1
============

From notes [here][2ch mt2] it appears that MT-2 is an "extended control
program" (拡張制御用プログラム) used with the MP-1010B I/O adapter
and a digital cassette recorder such as the MP-3030. (Examples can be
seen [in this auction][w482610609] ([archived page][w482610609 ia]).
This is said to have 500 KB capacity and a transfer rate of 12 KB/sec.

It's in the printer ROM on the MB-6885; `CALL $E42B` to start it. After it
times out with `NOT READY`, the following commands are available at the `:`
prompt:

    E   Exit: go to monitor
    I   asks SURE?
    K   asks FILE NAME:
    L   asks FILE NAME:
    P   asks FILE NAME:, FROM (def. 0142), TO (def. 014C)
    V   asks FILE NAME:
    W   does nothing?



<!-------------------------------------------------------------------->
[2ch mt2]: https://bubble2.5ch.net/test/read.cgi/i4004/1008622217//?v=pc
[w482610609 ia]: https://web.archive.org/web/20220704144128/https://yahoo.aleado.com/lot?auctionID=w482610609
[w482610609]: https://yahoo.aleado.com/lot?auctionID=w482610609

PC-8001 Programs
================

      10 CONSOLE 0,25,1,0
      20 WIDTH 80,25
      30 COLOR 0,0,1
      40 PRINT CHR$(12)
      50 A=RND(1)*5:B=RND(1)*5
      60 FOR I=1 TO 800
      70 Y=SIN(I/100*A)*45+46
      80 X=COS(I/100*A)*45+80
      90 PSET(X,Y)
     100 NEXT
     110 GOTO 10

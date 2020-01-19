# Hot Air

Hot air balloon "game". I wrote this game when 13 years old. In Visual Basic.
It was my first computer program. Now rewriting in Elm, mostly... to see what
Elm is like, I guess? [Edit: turns out Elm is pretty neat!]

## Install/Run

On Ubuntu, install Elm and run the reactor in this directory:

```
$ npm install elm
$ elm reactor
```

Do whatever elm reactor tells you to, probably visit http://localhost:8000.

## Play

So, this is not very intuitive... there are two players in balloons (marked by
'o'), trying to collect treasure (marked by numbers 1, 2, 3). On the left hand
side, the darker background, is a map-like top-down view on the playing field.
The right hand side is a sideway view, showing the height of each player's
balloon and where the wind is blowing at that height. To collect the treasure
you not only need to be not at the right place but also to land (height zero,
where the wind is not blowing). At the top right are both player's scores.

The cyan player moves up/down by pressing 'a' and 'z'.
The blue player moves up/down by pressing the up and down arrows.

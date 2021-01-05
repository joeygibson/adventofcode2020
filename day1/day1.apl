R←combos VALS;val;pos;others
⍝ a function to solve part 1
R←⍬
:For val :In VALS
    others←VALS~val
    pos←(others=(2020-val))
    R←R,pos/others
:EndFor

R←×/R


R←combos3 VALS;val;val1;pos;others;others1
⍝ a function to solve part 2
R←⍬
:For val :In VALS
    others←VALS~val
    :For val1 :In others
        others1←others~val1
        pos←(others1=(2020-(val+val1)))
        R←R,pos/others1
    :EndFor
:EndFor

R←((⍳⍴R)=(R⍳R))/R
R←×/R


⍝ read the data file
file←⍎¨⊃⎕nget '/Users/jgibson/Projects/adventofcode2020/day1/input1.txt'1

⍝ solve part 1
combos data
⍝ solve part 2
combos3 data

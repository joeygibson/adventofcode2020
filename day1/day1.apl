⍝ a function to convert lines from the file to integers
 R←cvt LINES;Ferret
 Ferret←{⍵[2]}
 R←Ferret¨(⎕VFI¨LINES)
 R←⊃¨⊃¨R

⍝ a function to solve part 1
 R←combos VALS;val;pos;others
 R←⍬
 :For val :In VALS
     others←VALS~val
     pos←(others=(2020-val))
     R←R,pos/others
 :EndFor

 R←×/R

⍝ a function to solve part 2
 R←combos3 VALS;val;val1;pos;others;others1
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
file←⊃⎕NGET'input.txt' 1

⍝ convert the lines to a vector of integers
data←cvt file

⍝ solve part 1
combos data
⍝ solve part 2
combos3 data

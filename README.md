# A new program for reading punchcards in Fortran
Being a big Geocaching fan, I came across [this geocache puzzle](https://coord.info/GC37XF9) and decided that, given it uses a punchcard, and because I've always been curious about Fortran, decided this was the right time to sit down and learn enough of the language to decipher the card. I spent a day on it and came up with the program; I'm making it available to anyone who'd like to decode punchcards and happen to have them in the same format as me (12 rows of 80 columns, 1 = hole, 0 = no hole).

It's written in the F90-flavor of Fortran; I initially tried sticking to the F77 or earlier but funny enough I couldn't find a lot of documentation for earlier versions than F90, so I figured that was old enough to count.  😇
## `gc37xf9.card`
The actual punch card. It is a text file consisting of 80 columns, by 12 rows. A "1" means a hole, otherwise no hole. There may be other ways of representing cards in text files, but this is what I came up with.
## `codes.txt`
This file is a map of hole positions to character. The first two rows are "control" rows, which, along with the third row that also happens to be 0, determine what the character is if any of them are punched in a column (and some other row is punched).

The left column represents rows on the card, which are appended together to make a unique key. The column on the right is the actual printable character.
## `gc37xf9.f90`
The actual program. I tried to follow, as best I was able to discern, good Fortran programming style by using `IMPLICIT NONE`, which is somewhat analogous to VBA's `option explicit`.

The program first reads the `codes.txt` and then the card file (`gc37xf9.card` here) and then transposes the arrays (I really learned an appreciation of Fortran's array handling and matrix transposing doing this project!) and then goes through each column, and for each column read each row. If there is a "1" in the cell, the row is appended to the `key` variable and, when we've reached the 12th row (because the rows and columns are fixed, I didn't feel bad using hard-coded numbers here), we have the key to find in the `codes` array. I would have preferred to use a map/dictionary, but it appears no such structure exists in F90 and given the limited dataset, figured it was okay in this situation.
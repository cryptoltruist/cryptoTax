## cryptoTax 0.0.2 submission no 2

> Please omit the redundant "in R" at the end of your title.

Fixed.

> Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)

Fixed.

> \dontrun{} should only be used if the example really cannot be executed
(e.g. because of missing additional software, missing API keys, ...) by
the user. That's why wrapping examples in \dontrun{} adds the comment
("# Not run:") as a warning for the user. Does not seem necessary.
Please replace \dontrun with \donttest.

Fixed.

> Please unwrap the examples if they are executable in < 5 sec, or replace
dontrun{} with \donttest{}.

Fixed.

> You write information messages to the console that cannot be easily
suppressed.
It is more R like to generate objects that can be used to extract the
information a user is interested in, and then print() that object.
Instead of print()/cat() rather use message()/warning() or
if(verbose)cat(..) (or maybe stop()) if you really have to write text to
the console. (except for print, summary, interactive functions)
-> R/format_ACB.R; R/get_proceeds.R

Fixed.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
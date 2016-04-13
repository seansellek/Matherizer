# Matherizer

A simple gem to parse and solve infix notation mathematical expressions. Those are the kind you're used to seeing in school.

The gem uses a variation of the [shunting-yard algorithm](https://en.wikipedia.org/wiki/Shunting-yard_algorithm), with the exception that it builds a operation tree in preparation for evaluation rather than Reverse Polish Notation.

Matherizer also supports unary minus (think distributed negative signs as well as negative numbers), which is not supported by your standard implemetation of the Shunting-yard algorithm.

To use, simply call `Matherizer.evaluate(expression)`.


# Todo

* Matherizer already throws errors for certain formatting issues like mismatched parenthesis or illegal tokens, but it could support the user more in identifying other issues with the input string.


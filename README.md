## MetaHub 3 ##

A declarative, data-centered, relational programming language and logic engine.
MetaHub is designed to compile to standard, object-oriented imperative languages.
Currently the only target is C++.

### The Compiler ###

Compilation is translated through 6 stages.  Each stage has it's own independent data structures.
This is pretty heavy, but also very powerful and modular.

Your MetaHub code ->

1. General Parser ->
2. MetaHub Parser ->
3. Untyped MetaData ->
4. Typed MetaData ->
5. Logic ->
6. Imperative ->
	
-> Generated code in target language.

	
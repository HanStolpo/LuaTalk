% Introduction to Lua the Extensible Extension Language
% Handré Stolp
% 8th April 2013

Introduction
========================================

What is Lua
----------------------------------------
* It is an embeddable scripting language
* It is dynamically typed
* It runs on a register-based virtual machine
* It has automatic memory management with incremental GC
* It has simple procedural _C_ and _Pascal_ like syntax
* It has good support for functional and declarative paradigms
    * Functions are first class objects
    * Lexically scoped closures
    * Tail recursion
* Its is portable and minimalist
	* Portable ANSI C
	* Does not come with batteries
	* Can squeeze runtime and standard libraries into 

The Language 
========================================

Comments
----------------------------------------

```lua
-- This is a single line comment
--[[ This is a multiline 
     comment
--]]
--[=[ This is a multiline 
     comment
    --[[ 
        With a nested multiline 
        comment
    --]]

    Any amount of `=` allowed the start and end count must just match
--]=]
```

Statements
----------------------------------------
* Each line is a new statement and default scope is global

    ```lua
    a = 1       -- global variable 
    local b = 2 -- prepend with 'local' to bind to lexical scope
    ```

* Standard standard *C* and *Pascal* like binary operators

    ```lua
    e = a + b       -- add
    e = a - b       -- subtract
    e = a * b       -- multiply
    e = a % b       -- modulus
    e = a ^ b       -- a to power b
    e = a == b      -- equality
    e = a ~= b      -- inequality
    e = a < b       -- less than
    e = a > b       -- greater than
    e = a <= b      -- less than equal
    e = a >= b;     -- greater than equal
    e = "ss" .. "XX"-- string concatenation
    ```

Statements continued
----------------------------------------
* Multiple assignment supported and multiple statements per line separated by **;**

    ```lua
    a, b = b, a         -- this swaps the values of a and b
    local c = 3; d = 4; -- multiple statements per line
    -- define local variable e with no value bound to it
    local e;            -- ';' not necessary but OK.
    ```

* Logical operators a bit different (**nil** and **false** is false everything else is true)

    ```lua
    -- stops on false or nil , returns last evaluated value
    e = a and b         -- if a true then b else false
    -- stops on true (not false or nil ), returns last evaluated value
    e = a or b          -- if a true then a else b
    -- Logically invert 
    e = not a           -- if a true then true else false
    -- using and and or for conditional assignment
    e = IAmNotDefined or 'So default value' 
    e = e and IAmNotDefinedButDoesntMatter
    ```

Types
----------------------------------------
All values in Lua are _first-class_ (stored in variables; passed as arguments; returned as results)

nil
:   The bottom type signifying nothing
boolean
:   The logical type can either be `true` or  `false`.
:   `nil` and `false` counts as false everything else is true.
number
:   The only arithmetic type. 
:   Runtime dependant usually `double` (could be `char`, `short`, `int`, `float`).
string
:   Immutable array of 8-bit `char` values.
:   8-bit clean i.e. may include embedded zeros `'\0'`


Types continued
----------------------------------------
function 
:   Any function defined in _Lua_
:   Any function defined in _C_ and exposed to _Lua_
:   Any compiled file or string of _Lua_ statements
thread 
:   Represents independent thread of execution.
:   Not _OS_ threads used for coroutines
userdata
:   Arbitrary _C_ data to be stored in _Lua_
:   Only operations are assignment and identity test
table
:   The only data structure in _Lua_
:   Associative arrays
:   Heterogeneous in value and key (any type except `nil`)

Strings
---------------------------------------
* Escaped strings
    * `'Some\n "blah" string'`
    * `"Some\n 'blah' string"`

Control structures
----------------------------------------
do block end
:   Introduces local scope

    ```lua
    do
        local onlyVisibleHere = 5
    end
    ```
if then else
:   Conditional branching with each branch introducing a local scope.

    ```lua
    if a == b then      -- start if branch
        e = 2
    elseif a == c then  -- optional else if branch
        e = 3 
    else                -- optional else branch
        e = 4
    end                 -- required terminator
    ```

Control structures continued
----------------------------------------
while
:   If condition is true then repeatedly execute block until false

    ```lua
    local a,b = 1,5
    while a < b do
        a = a + 1       -- executes 4 times
    end
    ```
repeat
:   Execute block and if condition is true repeat until false

    ```lua
    local a,b = 4,5
    repeat
       a = a + 1        -- executes 2 times
    until a == b
    ```
break
:   Forces enclosing looping structure to terminate immediately

    ```lua
    local a = 1
    while true do
        break
        a = a + 1       -- never executes a remains 1
    end
    ```

Control structures continued
----------------------------------------
numerical for
:   Repeat the block until initial value passes limit incrementing by optional step size. 
    Default step size is 1.

    ```lua
    local a = 1
    for u=1,10 do
        a = u       -- executes 10 times (at end a == 10)
    end
    for u=10,1,-1 do
        a = u       -- executes 10 times (at end a == 1)
    end
    ```

generic for
:   The generic for loop works over functions called iterators. On each iteration, the 
    iterator function is called to produce a new value, stopping when this new value is nil.

    ```lua
    local a = 1
    for k,v in ipairs {0,1,2,3,4,5,6,7,8,9} do
        a = k + v       -- executes 10 times (at end a == 10 + 9)
    end
    ```

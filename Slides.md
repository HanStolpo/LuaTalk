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
	* Can squeeze runtime and standard libraries into approximately 98 KB 

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
    * `'Some\n "blah" string'` don't need to escape `"`
    * `"Some\n 'blah' string"` don't need to escape `'`
* Literal strings

    ```lua
    local someString = [[
    first new line is ignored
    this is a new line but this \n is not
    ]]

    local anotherString = [=[the string does not end here]]
    [[some text]]
    the string ends here]=]
    ```

Tables
--------------------------------------
* Indexing

    ```lua
    a = t[1]        -- access array element 1
    a = t['blah']   -- access element string key 'blah'
    a = t.blah      -- syntactic sugar for t['blah']
    ```

* Constructors

    ```lua
    -- empty table
    t = {}

    -- simple array elements are t[1], t[2], t[3]
    t = {"blah", 1, true}

    -- simple map elements t['blah'], t['foo']
    t = {blah = 5, foo=true}

    -- Explicit keys
    t = {['blah'] = 5, [100] = true}

    -- mixed elements at t[1], t[2], t[100], t.foo t.bar
    t = 
    {   'alpha', 'bravo';   -- element separator either , or ;
        foo = 5; bar=4
        [100] = false,
    }
    ```
* Insertion and deletion

    ```lua 
    t.foo = 5   -- Insert value 5 at key foo
    t.foo = nil -- Delete key foo from table
    ```

Functions
---------------------------------------------
* All functions have an environment
    * The environment is a Lua table
    * Global write inserts into the table
    * Global read performs table lookup
    * Local values shadow global values
* A Lua file is actually a function
* Function definition

    ```lua
        function (arg1, arg2) return arg1 + arg2 end
    ```

    * Start function scope with keyword `function`
    * Follow it with argument list `(a1, a2, ...)`
    * End function scope with keyword `end`
    * All statements between start and end are in function scope
    * Optional keyword `return` returns functions result 
* Global function assignment

    ```lua
    -- This is syntax sugar
    function arb (arg1, arg2) return arg1 + arg2 end
    -- for this assignment of a function to the global 'arb'
    arb = function (arg1, arg2) return arg1 + arg2 end 
    ```

* Local function assignment

    ```lua
    -- This is syntax sugar
    local function arb (arg1, arg2) return arg1 + arg2 end
    -- for this assignment of a function to the local 'arb'
    local arb = function (arg1, arg2) return arg1 + arg2 end 
    ```

Functions continued
---------------------------------------------
* Table function insertion

    ```lua 
    -- This is syntax sugar
    function t.arb (arg1, arg2) return arg1 + arg2 end
    -- for this insertion of a function into table t at key arb
    t['arb'] = function (arg1, arg2) return arg1 + arg2 end
    ```

* Table function insertion with implicit `self`

    ```lua 
    -- This is syntax sugar
    function t:arb (arg1, arg2) 
        return arg1 + arg2 + self[1]
    end
    -- for this insertion of a function into table t at key arb
    -- and implicit self parameter
    t['arb'] = function (self, arg1, arg2) 
        return arg1 + arg2 + self[1]
    end
    ```

* Function called by applying argument list to function value

    ```lua
    local arb = function (a) return a + a end
    local x = arb(2)    -- x is 4
    ```

* Calling function implicitly passing `self`

    ```lua
    local t = {
        arb = function(self, a) 
            return self.x + a 
        end; 
        x = 1; -- trailing delimiter is fine
    }
    -- This is syntax sugar for 
    local b = t:arb(2)
    -- this lookup of arb in t and passing it t and 2
    local c = t.arb(t, 2)
    ```

Functions continued
---------------------------------------------
* Parentheses optional when calling function with literal string 

    ```lua 
    -- This is syntax sugar
    print "blah"
    -- for this
    print("blah")
    ```

* Parentheses optional when calling function with table constructor

    ```lua 
    -- This is syntax sugar
    ipairs {1,2,3,4}
    -- for this
    ipairs ({1,2,3,4})
    ```

* Function return types are dynamic

    ```lua 
    function arb(x)
        if      x == 1      then   return 3,4
        elseif  x == 'j'    then   return 'bob',8
        elseif  x == 'm'    then   return nil,'s'
        elseif  x == 2      then   return 4
        else
            -- returning nothing
        end
    end
    a,b = arb(1)    -- a == 3, b == 4
    a,b = arb('j')  -- a == 'bob', b == 8
    a,b = arb('m')  -- a == nil, b == 's'
    a,b = arb(2)    -- a == 4, b == nil
    a,b = arb(3)    -- a == nil, b == nil
    ```

Functions continued 
---------------------------------------------
* Functions support closures

    ```lua
    local function makeCounter()
        local count = -1            -- local variable
        return function ()          -- return the function
            -- capture `count` updating on each invocation
            return count = count + 1
        end
    end
    local c1 = makeCounter()
    local _1, _2, _3 = c1(), c1(), c1() -- _1 == 0, _2 == 1, _3 == 2
    local c2 = makeCounter()
    _1, _2, _3 = c2(), c1(), c2()       -- _1 == 0, _2 == 4, _3 == 1
    ```

* Functions support tail call recursion

    ```lua
    function fib(n)
        local _fib(fn2, fn1, at)
            if at == n then 
                return fn1 + fn2
            else
                return _fib(fn1, fn1 + fn2, at+1)
            end
        end
        if n <= 0 then return 0
        elseif n == 1 then return 1
        else return _fib(0, 1, 2)
    end
    -- no stack overflow
    local c = fib(10000)
    ```

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

Extensibility (Meta table)
-------------------------------------
* Can extend tables and userdata using meta tables
* Meta table is a plain _Lua_ table
* Meta table bound to userdata or table using `setmetatable(t, mt)` function
* Inserting functions at specific keys specialize behaviour
    * Arithmetic : `__add`, `__sub` etc.
    * Comparison : `__eq`, `__lt` and `__le`.
    * Key lookup and new key insertion : `__index` and `__newindex`
    * Function call (using object as a function): `__call`
    * Finalizers : `__gc` must be set from _C_
* Meta tables used 

Metatable example
--------------------------------------

> * Fibber object based on some number `n`
> * Fibbers can be added or subtracked 
> * Can't add any values to fibbers
> * Applying function call to fibbers returns n_th fibonacci number

```lua
local mtFibber = {}
function makeFibber(n)
    local f = {n = n}
    setmetatable(f, mtFibber)
    return f
end
do
    function mtFibber:__call()
        local n = math.max(self.n,0)
        local function _fib(fn2, fn1, at)
            if at == n then 
                return fn1 + fn2
            else
                return _fib(fn1, fn1 + fn2, at+1)
            end
        end
        if n <= 0 then return 0
        elseif n == 1 then return 1
        else return _fib(0, 1, 2) end
    end
    function mtFibber.__add(lhs, rhs) return makeFibber(lhs.n + rhs.n) end
    function mtFibber.__sub(lhs, rhs) return makeFibber(lhs.n - rhs.n) end
    function mtFibber:__newindex(k,v) assert(false, "can't add members") end
end
local f1 = makeFibber(10)
local f2 = makeFibber(5)
local f3 = makeFibber(100)
local f4 = (f3 + f2 - f1)
-- The 95th fibonacci is 3.194043463499e+019
print ("The " .. f4.n .. "nth fibonacci number is " .. f4())
```

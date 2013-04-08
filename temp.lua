
--require "metalua"
--dofile "match_test.mlua"

local cosmo = require "cosmo"
mycards = { {rank="Ace", suit="Spades"}
		  , {rank="Queen", suit="Diamonds"}
		  , {rank="10", suit="Hearts"} 
		  } 
template = "$do_cards[[$rank of $suit, ]]"
-- prints Ace of Spades, Queen of Diamonds, 10 of Hearts,
print (cosmo.fill(template, {do_cards = mycards}))


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


    function fib(n)
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
    -- no stack overflow
    local c = fib(10000)
	print (c)

local List = require 'pl.List'	
local func = require 'pl.func'	
print (List{10,20,30}:map(_1+1):reduce '+')	-- prints 63


class = require 'pl.class'

class.Animal()

function Animal:_init(name)
    self.name = name
end

function Animal:__tostring()
  return self.name..': '..self:speak()
end

class.Dog(Animal)

function Dog:speak()
  return 'bark'
end

class.Cat(Animal)

function Cat:_init(name,breed)
    self:super(name)  -- must init base!
    self.breed = breed
end

function Cat:speak()
  return 'meow'
end

fido = Dog('Fido')
felix = Cat('Felix','Tabby')

print(fido,felix)        -- Fido: bark      Felix: meow     Leo: roar
print(felix:is_a(Animal))-- true
print(felix:is_a(Dog))   -- false
print(felix:is_a(Cat))   -- true

	

require "iuplua"
require "iupluacontrols"
local label
local text = ""
local function onText(self)
	text = string.upper(self.value)
end
local function modifyLabel(self)
	if label then 
		label.title = text
	end
end

dlg = iup.dialog
{
	iup.vbox
	{
		iup.label{title = 'A silly little dialog', map_cb = function(self) label = self end},
		iup.vbox
			{
				iup.hbox
				{
					iup.label{title='Write text', size="80"},
					iup.text{size="80", valuechanged_cb = onText}
					;margin="0", gap="10"
				};
				iup.hbox
				{
					iup.button{title="Ok",size="40", action = modifyLabel},
					iup.button{title="Cancel",size="40" , action = function () return iup.CLOSE end}
					;margin="0", gap="10"
				};	
			}
		;margin="5x5", gap="5"
	}
	;title="Some dialog", resize="NO"
}
dlg:popup()




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
	

require "iuplua"
require "iupluacontrols"
local text = ""
local function filterText()
end
dlg = iup.dialog
{
	iup.vbox
	{
		iup.label{title = 'A silly little dialog'},
		iup.vbox
			{
				iup.hbox
				{
					iup.label{title='Write text', size="80"},
					iup.text{size="80", action = filterText}
					;margin="0", gap="10"
				};
				iup.hbox
				{
					iup.label{title='name space', size="80"},
					iup.text{size="80", action = filter_name_space}
					;margin="0", gap="10"
				};
				iup.hbox
				{
					iup.button{title="Ok",size="40", action = on_ok},
					iup.button{title="Cancel",size="40" , action = on_cancel}
					;margin="0", gap="10"
				};	
			}
		;margin="5x5", gap="5"
	}
	;title="Some dialog", resize="NO"
}
dlg:popup()



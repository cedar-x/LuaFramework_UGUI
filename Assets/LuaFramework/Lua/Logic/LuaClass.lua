--Author : Administrator
--Date   : 2014/11/25

--声明，这里声明了类名还有属性，并且给出了属性的初始值。
LuaClass = {x = 0, y = 0}

--这句是重定义元表的索引，就是说有了这句，这个才是一个类。
LuaClass.__index = LuaClass

--构造体，构造体的名字是随便起的，习惯性改为New()
function LuaClass:New(x, y) 
    local self = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(self, LuaClass);  --将self的元表设定为Class
    self.x = x;
    self.y = y;
    return self;    --返回自身
end

--测试打印方法--
function LuaClass:test() 
    logWarn("x:>" .. self.x .. " y:>" .. self.y);
end

--endregion

--类继承-----------------------------------------------
	_G.object = {}

	setmetatable(object, {__call =
		function ( base ,init)
			local function createClass( base ,init)
				local class = init or {};
				class . base = base
				class .constructor= false
				class .instance= function (self, o, ...)
					local obj={}
					local arg = {...};
					--copy from self( class prototype)
					for k,v in pairs(self) do
						obj[k] = v;
					end
					if (type(o) == "table" ) then
						--copy from o
						for k,v in pairs(o) do
							obj[k] = v;
						end
					else
						table.insert(arg, 1, o);
					end
					
					do
						local function call_constructor(c,...)
							if c.constructor then
								c.constructor(obj,...)
							end
							if c. base then
								call_constructor(c. base ,...)
							end
						end
						call_constructor( class ,unpack(arg))
					end
					setmetatable(obj,{ __index=self.base })
					return obj
				end
				setmetatable( class ,{
				__call = createClass,
				__index = class . base
				})
				
				return class
			end;

			return createClass( base ,init);
		end;
	});

	_G.new = function(class, init, ...)
		return class:instance(init, ...);
	end

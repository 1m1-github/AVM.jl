1+1

using Pkg
Pkg.generate(".")
Pkg.activate(".")
Pkg.add("Test")


prog = "1 + 1"
ex1 = Meta.parse(prog)
typeof(ex1)

ex1.head
ex1.args

ex2 = Expr(:call, :+, 1, 1)
ex1 == ex2
dump(ex2)

ex3 = Meta.parse("(4 + 4) / 2")
Meta.show_sexpr(ex3)

ex = :(a+b*c+1)
dump(ex)

ex = quote
    x = 1
    y = 2
    x + y
end
typeof(ex)
ex.head
ex.args[2].args

Meta.show_sexpr(:(
    begin
        s=0
        for i in 1:10
            s += i
        end
        s
    end
))

Meta.show_sexpr(:(
    begin
        f(x)=0
        s=0
        while i < 11
            s += f(i)
            i += 1
        end
        s
    end
))

g(a) = begin
    f(x)=2x
    s=0
    i=0
    while i < a
        s += f(i)
        i += 1
    end
    s
end

Meta.show_sexpr(:(g(a) = begin
    f(x)=2x
    s=0
    i=0
    while i < a
        s += f(i)
        i += 1
    end
    s
end))
Meta.dump(:(g(a::CCC) = begin
    f(x)=2x
    s=0
    i=0
    while i < a
        s += f(i)
        i += 1
    end
    s
end))
a=:(g(a) = begin
    f(x)=2x
    s=0
    i=0
    while i < a
        s += f(i)
        i += 1
    end
    s
end)
a.head
a.args[2].args[3].args[2].head
a.args[2].args[3].args[2].args[2].head
map(typeof,a.args[2].args[3].args[2].args[2].args)

Meta.show_sexpr(:(g(2)))
a=Meta.parse("""
function foo(x)
    y = sin(x)
    if x > 5.0
        y = y + cos(x)
    end
    return exp(2) + y
end
"""
)
using InteractiveUtils
@code_typed foo(1.0)
Meta.show_sexpr(:(foo(a)))
a.head
a.args
a.args[1]
a.args[1].head
a.args[1].args
a.args[2].head
a.args[2].args
a.args[2].args[3]
a.args[2].args[3].head
a.args[2].args[3].args
a.args[2].args[3].args[2].head
a.args[2].args[3].args[2].args
typeof(a.args[2].args[3].args[2].args[1])

abstract type AA end
const AAA = UInt64
const BBB = UInt32
const CCC = UInt128

g
methods(g)
c = code_typed(g, (AAA,), optimize=true)
c = code_typed(g, (BBB,), optimize=true)
c = code_typed(g, (CCC,), optimize=true)
c = code_typed(g, (UInt128,), optimize=true)
c[1][1].code
c[1][1].slotnames
c[1][1].slotflags
c[1][1].ssavaluetypes
c[1][1].slottypes
c[1][1].rettype
c[1][2]
c[1][1].code[2]
map(typeof, c[1][1].code)
c[1][1].code[2].edges
c[1][1].code[2].values
c[1][1].code[3].edges
c[1][1].code[3].values
fieldnames(typeof(c[1][1].code[end]))



ex = quote
    s=0
    for i in 1:10
        s += i
    end
    s
end
dump(ex)
ex.args[4].head
ex.args[4].args[1].head
ex.args[4].args[1].args
ex.args[4].args[1].args[2]
ex.args[4].args[1].args[2].head
ex.args[4].args[1].args[2].args
ex.args[4].args[2].head
ex.args[4].args[2].args[2].head
typeof(ex.args[4].args[2].args[2].head)
ex.args[4].args[2].args[2].args
typeof(ex.args[4].args[2].args[2].args[1])
typeof(ex.args[4].args[2].args[2].args[2])

Meta.show_sexpr(:(x = 1))
Meta.show_sexpr(:(x + 1))
Meta.show_sexpr(:(x + 1))

f(x) = x + 2
@code_llvm f(3)

@generated function goo(x)
    Core.println(x)
    return :(x * x)
end
x = goo(2)
y = goo("bar")
goo(4)

typeof(0)
typeof(1)
a = :(1+1)
a.head
a.args
typeof(a.args[2])
Meta.parse("1+1")
Base.Meta.lower(@__MODULE__, :(1+1))
a = @code_typed 1+1
@code_llvm 1+1
@code_native 1+1
eval

a[1]
a[2]
fieldnames(typeof(a[1]))
a[1].code
a[1].codelocs
a[1].purity


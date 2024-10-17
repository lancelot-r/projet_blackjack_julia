# Definition des types d'expressions

abstract type Expr end

struct Const <: Expr
    value::Number
end

struct Var <: Expr
    name::Symbol
end

struct Add <: Expr
    left::Expr
    right::Expr
end

struct Mul <: Expr
    left::Expr
    right::Expr
end

struct Pow <: Expr
    base::Expr
    exponent::Number
end

struct Func <: Expr
    func::Symbol   # :sin, :cos, :exp, :log, etc.
    arg::Expr
end

# Creation de la fonction derivative

# Derivée d'une constante :
function derivative(e::Const, var::Symbol)
    return Const(0)
end

# Derivée d'une variable
function derivative(e::Var, var::Symbol)
    if e.name == var
        return Const(1)
    else
        return Const(0)
    end
end

# Derivée d'une addition
function derivative(e::Add, var::Symbol)
    left_deriv = derivative(e.left, var)
    right_deriv = derivative(e.right, var)
    return Add(left_deriv, right_deriv)
end

# Derivée d'une multiplication
function derivative(e::Mul, var::Symbol)
    left_deriv = derivative(e.left, var)
    right_deriv = derivative(e.right, var)
    return Add(Mul(left_deriv, e.right), Mul(e.left, right_deriv))
end

# Derivée d'une puissance
function derivative(e::Pow, var::Symbol)
    n = e.exponent
    u = e.base
    u_deriv = derivative(u, var)
    return Mul(Mul(Const(n), Pow(u, n - 1)), u_deriv)
end

# Derivée d'une fonction
function derivative(e::Func, var::Symbol)
    f = e.func
    u = e.arg
    u_deriv = derivative(u, var)
    return Mul(func_derivative(f, u), u_deriv)
end

# Fonction auxiliaire pour les dérivées des fonctions de base
function func_derivative(f::Symbol, u::Expr)
    if f == :sin
        return Func(:cos, u)
    elseif f == :cos
        return Mul(Const(-1), Func(:sin, u))
    elseif f == :exp
        return Func(:exp, u)
    elseif f == :log
        return Pow(u, -1)
    else
        error("Fonction non prise en charge: $f")
    end
end

# Simplifications

function simplify(e::Const)
    return e
end

function simplify(e::Var)
    return e
end

function simplify(e::Add)
    left = simplify(e.left)
    right = simplify(e.right)

    # Si l'un des opérandes est zéro
    if left isa Const && left.value == 0
        return right
    elseif right isa Const && right.value == 0
        return left
    # Si les deux opérandes sont des constantes
    elseif left isa Const && right isa Const
        return Const(left.value + right.value)
    else
        return Add(left, right)
    end
end

function simplify(e::Mul)
    left = simplify(e.left)
    right = simplify(e.right)

    # Si l'un des opérandes est zéro
    if (left isa Const && left.value == 0) || (right isa Const && right.value == 0)
        return Const(0)
    # Si l'un des opérandes est un
    elseif left isa Const && left.value == 1
        return right
    elseif right isa Const && right.value == 1
        return left
    # Si les deux opérandes sont des constantes
    elseif left isa Const && right isa Const
        return Const(left.value * right.value)
    else
        return Mul(left, right)
    end
end

function simplify(e::Pow)
    base = simplify(e.base)
    exponent = e.exponent

    # Exposant zéro
    if exponent == 0
        return Const(1)
    # Exposant un
    elseif exponent == 1
        return base
    # Si la base est une constante
    elseif base isa Const
        return Const(base.value ^ exponent)
    else
        return Pow(base, exponent)
    end
end

function simplify(e::Func)
    arg = simplify(e.arg)

    # Si l'argument est une constante, évaluer la fonction
    if arg isa Const
        value = evalfunc(e.func, arg.value)
        return Const(value)
    else
        return Func(e.func, arg)
    end
end

function evalfunc(f::Symbol, x::Number)
    if f == :sin
        return sin(x)
    elseif f == :cos
        return cos(x)
    elseif f == :exp
        return exp(x)
    elseif f == :log
        return log(x)
    else
        error("Fonction non prise en charge: $f")
    end
end

# Affichage des résultats

function Base.show(io::IO, e::Const)
    print(io, e.value)
end

function Base.show(io::IO, e::Var)
    print(io, e.name)
end

function Base.show(io::IO, e::Add)
    print(io, "(")
    print(io, e.left)
    print(io, " + ")
    print(io, e.right)
    print(io, ")")
end

function Base.show(io::IO, e::Mul)
    left_needs_parens = e.left isa Add
    right_needs_parens = e.right isa Add

    if left_needs_parens
        print(io, "(")
        print(io, e.left)
        print(io, ")")
    else
        print(io, e.left)
    end

    print(io, " * ")

    if right_needs_parens
        print(io, "(")
        print(io, e.right)
        print(io, ")")
    else
        print(io, e.right)
    end
end

function Base.show(io::IO, e::Pow)
    base_needs_parens = e.base isa Add || e.base isa Mul

    if base_needs_parens
        print(io, "(")
        print(io, e.base)
        print(io, ")")
    else
        print(io, e.base)
    end

    print(io, "^")
    print(io, e.exponent)
end

function Base.show(io::IO, e::Func)
    print(io, string(e.func))
    print(io, "(")
    print(io, e.arg)
    print(io, ")")
end

# Exemple : 
x = Var(:x)

## f(x) = x^2 + 3x + 5
expr = Add(
    Add(
        Pow(x, 2),
        Mul(Const(3), x)
    ),
    Const(5)
)

## Calcul de la derivée
d_expr = derivative(expr, :x)

## Simplification

d_expr_simplified = simplify(d_expr)

println(d_expr_simplified)

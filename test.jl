using DataFrames
using LinearAlgebra
using CSV

function sumOfColumn(x)
    sum = 0
    N = length(x)
    if mod(N, 2) == 0
        len = convert(Int64, N/2)
        for i = 1:len
            sum = sum + x[i] + x[N-i+1]
        end
    else
        len = convert(Int64, (N-1)/2)
        for i = 1:len
            sum = sum + x[i] + x[N-i+1]
        end
        sum = sum + x[convert(Int64,(N+1)/2)]
    end
    return sum
end

function squareColumnElement(x)
    squaredColumn = [0 for i in x]
    for i in x
        squaredColumn[i] = x[i]*x[i]
    end
    return squaredColumn
end

function printMatrix(M)
    rows, cols = size(M)
    for i = 1:rows
        for j = 1:cols
            print(M[i, j])
            print("\t")
        end
        print("\n")
    end
end

function getDependentVar(df, col)
    newdf = select!(df, col)
    return newdf
end

function getIndependentVar(df, col)
    newdf = select!(df, Not(col))
    return newdf
end

function convertToNumeric(df,col)
    i = 1
    for category in col
        category = i
        i += 1
    end
    return df
end

function isNotExist(list, target)
    for item in list
        if (target == item)
            return false
        end
    end
    return true
end


function changeCatToNum(col)
    newcol = []
    category = []
    for i = 1:length(col)
        if (isNotExist(category, col[i]))
            push!(category, col[i])
        end
    end

    numeric = []
    for i = 1:length(category)
        push!(numeric, i)
    end

    for i=1:length(col)
        for j=1:length(category)
            if (col[i] == category[j])
                push!(newcol, numeric[j])
            end
        end
    end
    return newcol
end

function meanOfX(col)
    return sumOfColumn(col)/length(col)
end

function correlation(x, y)
    xbar = meanOfX(x)
    ybar = meanOfX(y)
    DiffX = x .- xbar
    DiffY = y .- ybar
    product = DiffX .* DiffY
    SquaredDiffX = DiffX .^2
    SquaredDiffY = DiffY .^2
    return sumOfColumn(product)/sqrt(sumOfColumn(SquaredDiffX)*sumOfColumn(SquaredDiffY))
end

function dotproduct(a, b)
    x = size(a,1)
    y = size(b,2)
    # hasil = Array{Float64,2}(undef,x,y)
    hasil = zeros(Float64,x,y)
    for i in 1:x
        for j in 1:y
            for k in 1:size(a,2)
                hasil[i,j] += a[i,k] * b[k,j] 
            end
        end
    end
    return hasil
end

function findRegConstant(indep, dependent)
    nrow = size(indep, 1)
    add = [1 for i=1:nrow]
    independent = hcat(add, indep)
    
    a = inv(dotproduct(transpose(independent), independent))
    b = dotproduct(a, transpose(independent))
    c = dotproduct(b, dependent)

    return c
end


function printRegression(list)
    string = "" 
    print(string)
    for i=1:length(list)
        x = list[i]
        if (i > 1)   
            string = string * " + ($x)" * "x$(i-1)"
        else
            string = string * "y = $x"
        end
    end
    print(string)
end


x = [0 0 0 ; 1 0 0; 0 1 0; 0 0 1]
y = [1, 2, 3, 4]

#print(findRegConstant(x, y))




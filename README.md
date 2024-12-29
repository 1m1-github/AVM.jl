this project will be developed as part of the larger project: https://github.com/1m1-github/1m1

# juliaTEAL

Translate julia -> TEAL as follows:

map julia function (or ir token) to TEAL opcode as early as possible

`Expr` with `head == :call` => map to overwritten function

# mapping

Opcodes
julia

TDD
FairTreasury is 1st test for JuliaTEAL
JuliaAVM+ is 1st test for JuliaTEAL

(JuliaAVM+ arb prec decimal float elemtary functions)

a function per opcode, with io

end with array of bytes

## Example 1

Consider the "Simple PyTeal Example" (https://developer.algorand.org/docs/features/asc1/teal/pyteal/)

The following TEAL code...

```
txn TypeEnum
int 1
==
txn Receiver
addr ZZAF5ARA4MEC5PVDOP64JM5O5MQST63Q2KOY2FLYFLXXD3PFSNJJBYAFZM
==
&&
txn CloseRemainderTo
global ZeroAddress
==
&&
txn AssetCloseTo
global ZeroAddress
==
&&
```

...could be translated from the following julia code

```
function main(transaction, args)
    
    # checks
    transaction.TypeEnum ≠ 1 && return false
    transaction.Receiver ≠ "ZZAF5ARA4MEC5PVDOP64JM5O5MQST63Q2KOY2FLYFLXXD3PFSNJJBYAFZM" && return false
    transaction.CloseRemainderTo ≠ ZeroAddress && return false
    transaction.AssetCloseTo ≠ ZeroAddress && return false

    # all good
    return true
end
```

or from the following

```
function main(transaction, args)
    typeEnumCheck = transaction.TypeEnum ≠ 1
    receiverCheck = transaction.Receiver ≠ "ZZAF5ARA4MEC5PVDOP64JM5O5MQST63Q2KOY2FLYFLXXD3PFSNJJBYAFZM"
    closeRemainderToCheck = transaction.CloseRemainderTo ≠ ZeroAddress
    assetCloseToCheck = transaction.AssetCloseTo ≠ ZeroAddress

    return typeEnumCheck && receiverCheck && closeRemainderToCheck && assetCloseToCheck
end
```

or in many other ways according to julia.


## Example 2

Consider the example provided at the bottom of https://developer.algorand.org/docs/features/asc1/teal/

The following TEAL code...

```
txn CloseRemainderTo
addr SOEI4UA72A7ZL5P25GNISSVWW724YABSGZ7GHW5ERV4QKK2XSXLXGXPG5Y
==
txn Receiver
addr SOEI4UA72A7ZL5P25GNISSVWW724YABSGZ7GHW5ERV4QKK2XSXLXGXPG5Y
==
&&
arg 0
len
int 46
==
&&
arg 0
sha256
byte base64 QzYhq9JlYbn2QdOMrhyxVlNtNjeyvyJc/I8d8VAGfGc=
==
&&
txn CloseRemainderTo
addr RFGEHKTFSLPIEGZYNVYALM6J4LJX4RPWERDWYS2PFKNVDWW3NG7MECQTJY
==
txn Receiver
addr RFGEHKTFSLPIEGZYNVYALM6J4LJX4RPWERDWYS2PFKNVDWW3NG7MECQTJY
==
&&
txn FirstValid
int 67240
>
&&
||
txn Fee
int 1000000
<
txn RekeyTo
global ZeroAddress
==
&&
&&
```

...could be translated from the following julia code

```
function addr2_and_secret(transaction, args)
    # check transaction properties
    transaction.CloseRemainderTo ≠ "SOEI4UA72A7ZL5P25GNISSVWW724YABSGZ7GHW5ERV4QKK2XSXLXGXPG5Y" && return false
    transaction.Receiver ≠ "SOEI4UA72A7ZL5P25GNISSVWW724YABSGZ7GHW5ERV4QKK2XSXLXGXPG5Y" && return false

    # check provided secret
    lenght(args[0]) ≠ 46 && return false
    sha256(args[0]) ≠ "QzYhq9JlYbn2QdOMrhyxVlNtNjeyvyJc/I8d8VAGfGc=" && return false

    # all good
    return true
end

function addr1_and_timeout(transaction, args)
    # check transaction properties
    transaction.CloseRemainderTo ≠ "RFGEHKTFSLPIEGZYNVYALM6J4LJX4RPWERDWYS2PFKNVDWW3NG7MECQTJY" && return false
    transaction.Receiver ≠ "RFGEHKTFSLPIEGZYNVYALM6J4LJX4RPWERDWYS2PFKNVDWW3NG7MECQTJY" && return false

    # check timeout
    return 67240 < transaction.FirstValid
end

function main(transaction, args)

    !addr2_and_secret(transaction, args) && return false
    !addr1_and_timeout(transaction, args) && return false

    # check fee
    1000000 < transaction.Fee && return false

    # check ReKey
    transaction.RekeyTo ≠ ZeroAddress && return false

    # all good
    return true
end
```

===

immediate
stack
scratch
state
box

x = scratch(4)
x = scratch()
typeof(x) == ScratchAVM

dupn(n)
dupn(n, a)
dupn(a, n)
dupn(a; n)

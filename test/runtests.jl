using Test
using JuliaTEAL
# using CLI

const w1 = "w1"
const w1PK = "begin deputy one prize roof tomorrow where cable gallery magic acoustic clap finish memory erode bulk latin material actress case select inject better able clean"
const w1a1PK = "upgrade ritual flush mammal police boring leopard release opinion human struggle indicate awesome cause lottery quote thunder harvest balance drive perfect quick nurse absent perfect"
const w1a1Address = "DWPXUPOMCPC6JFWFM5AY3IBQBWPJ4PP7W5EMHW6KUS4DXCSVD3NPVZMNU4"

@test JuliaTEAL.versions() == "v2"

# simplestSmartContract
function testSimplestSmartContract()
    JuliaTEAL.compile(
        "simplestSmartContract.jl"
    )

    output = JuliaTEAL.createApp(
        "simplestSmartContract.jl.approve.teal",
        "simplestSmartContract.jl.clear.teal",
        w1a1Address,
        w1a1Address,
        w1,
    )
    outputs = split(output, " ")
    ix = findfirst(x -> x == "index", outputs)
    appId = parse(Int, outputs[ix+1])

    JuliaTEAL.callApp(
        appId,
        ["int:2"],
        w1a1Address,
        w1,
    )

    try
        JuliaTEAL.callApp(
            appId,
            ["int:1"],
            w1a1Address,
            w1,
        )
        return false
    catch end

    true
end
@test testSimplestSmartContract()
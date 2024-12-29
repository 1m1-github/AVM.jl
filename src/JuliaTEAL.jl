module JuliaTEAL

# import "./CLI.jl"

function compile(
    juliaTealFilePath
)
    approvalProgramTealFilePath = "$juliaTealFilePath.approve.teal"
    clearProgramTealFilePath = "$juliaTealFilePath.clear.teal"
    open(approvalProgramTealFilePath, "w") do file
        # todo create correct TEAL
        # would be correct: teal = "#pragma version 10\ntxn ApplicationID\nbz approve\ntxna ApplicationArgs 0\nbtoi\npushint 2\n%\nbz approve\nb fail\napprove:\npushint 1\nreturn\nfail:\npushint 0\nreturn"
        teal = ""
        write(file, teal)
    end
    open(clearProgramTealFilePath, "w") do file
        # todo create correct TEAL
        # would be correct: teal = "#pragma version 10\npushint 1"
        teal = ""
        write(file, teal)
    end
end

## CLI

const URL = "http://localhost:4001"

function versions()
    cmd = `algokit goal version`
    output = readchomp(cmd)
    m = match(r"\[(.*?)\]", output)
    m.captures[1]
end

function newWallet(walletName)
    cmd = `algokit goal wallet new $walletName`
    readchomp(cmd)
end

function newAccount(walletName)
    cmd = `algokit goal account new -w $walletName`
    readchomp(cmd)
end

function getAccountPK(accountAddress, walletName)
    cmd = `algokit goal account export --address $accountAddress -w $walletName`
    readchomp(cmd)
end

function createApp(
    approvalProg,
    clearProg,
    creator,
    signer,
    walletName,
    )
    cmd = `algokit goal app create --creator $creator --signer $signer --approval-prog $approvalProg --clear-prog $clearProg --wallet $walletName`
    readchomp(cmd)
end

function callApp(
    appId,
    args,
    creator,
    walletName,
)
    cmd = `algokit goal app call --from $creator --app-id $appId --wallet $walletName --app-arg=$args`
    readchomp(cmd)
end

end # module JuliaTEAL

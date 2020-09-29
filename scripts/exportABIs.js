const BEP20Token = artifacts.require("BEP20Token");
const Staking = artifacts.require("Staking");
fs = require('fs');

module.exports = async function () {
    try {
        const token = await BEP20Token.deployed()
        path = "./abi/token.abi"
        await exportFile(path, token.abi)
        //const stake = await Staking.deployed()
        //console.log(stake.abi)
    } catch (err) {
        console.log(err)
    }
}


function exportFile(name, obj) {
    let data = JSON.stringify(obj)
    return new Promise((resolve, reject) => {
        fs.writeFile(name, data, function (err) {
            if (err) return reject(err)
            console.log("Abi file exported => ", name)
            resolve()
        });
    })
}

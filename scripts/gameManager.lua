local gameManager = {}
currentMoney = 100

function gameManager.addMoney(amount)
    currentMoney = currentMoney + amount
end

function gameManager.canBuy(cost)
    return currentMoney >= cost
end

return gameManager
require('dotenv').config()
const mineflayer =require("mineflayer")
const { pathfinder, Movements, goals } = require("mineflayer-pathfinder")

const bot = mineflayer.createBot({
    host: process.env.HOST,
    port: parseInt(process.env.PORT || "25565"),
    username: "bot_1",
    version: "1.20.1"
})
console.log("connecting to " + process.env.HOST + ":" + process.env.PORT)

bot.loadPlugin(pathfinder)
bot.on("spawn", () => {
    bot.chat("Hello, world!")
})

bot.once("spawn", () => {
    const mcData = require('minecraft-data')(bot.version)
    const defaultMove = new Movements(bot, mcData)
    bot.pathfinder.setMovements(defaultMove)

    // walk in a 10 block radius every 5 seconds
    setInterval(() => {
        const x = bot.entity.position.x + (Math.random() * 20 - 10)
        const z = bot.entity.position.z + (Math.random() * 20 - 10)
        const y = bot.entity.position.y
        bot.pathfinder.setGoal(new goals.GoalBlock(x, y, z))
    }, 5000)
})
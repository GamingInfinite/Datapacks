scoreboard players enable @a[tag=isOp] butcher
execute if score @p butcher matches 1 run kill @e[type=!player]
execute if score @p butcher matches 1 run scoreboard players set @a[tag=isOp] butcher 0
execute unless entity @a[tag=butcherDisabled] run function creativeutilities:objd/doloop1.mcfunction

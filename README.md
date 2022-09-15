# brp-fivem-appearance

This is something I made for my server a couple months ago I take no credit for the UI all I've done is make the LUA side with clothing shops, barber shops, tatto shops and saved outfits the original post was from https://forum.cfx.re/t/release-fivem-appearance/2438537

## Dependencies

- ESX
- FiveM Appearance https://github.com/pedr0fontoura/fivem-appearance
- BT-Polyzone https://github.com/brentN5/bt-polyzone
- OX Library https://github.com/overextended/ox_lib

## Conflicts

This rescorce is meant to replace these two so it cannot be used while these rescorces are running 
- esx_skin
- skinchanger

## Setup

- Run Outfits.sql

If you'r using esx_multicharacter or most rescorces using esx_skin or skinchanger this should work out of the box thansk to edits made by Linden however if it doeas not you can use the trigger below on the client side after the player loads in order to set their skin 

```cfg
ESX.TriggerServerCallback('fivem-appearance:getPlayerSkin', function(appearance)
    exports['fivem-appearance']:setPlayerAppearance(appearance)
end)
```

## Server Config

```cfg
ensure fivem-appearance
ensure brp-fivem-appearance
setr fivem-appearance:locale "en"
```

# Support Me

- https://www.buymeacoffee.com/ZiggyJoJo

- https://ziggys-scripts.tebex.io


## Preview

![](https://i.imgur.com/Cs1fvNC.jpeg"")
![](https://i.imgur.com/sA55YgF.jpeg"")
![](https://i.imgur.com/dR3U3Uu.jpeg"")
![](https://i.imgur.com/hyhXldt.jpeg"")
![](https://i.imgur.com/ACKPHv3.jpeg"")

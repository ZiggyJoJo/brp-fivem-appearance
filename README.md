# brp-fivem-appearance

This is something I made for my server a couple months ago I take no credit for the UI all I've done is make the LUA side with clothing shops, barber shops and saved outfits the original post was from https://forum.cfx.re/t/release-fivem-appearance/2438537

## Dependencies

- ESX
- NeroHiro’s Context Menu https://forum.cfx.re/t/release-standalone-nerohiro-s-context-menu-dynamic-event-firing-menu/2564083
- NeroHiro’s Keyboard (Can be easily replaced) https://forum.cfx.re/t/release-standalone-nerohiro-s-keyboard-dynamic-nui-keyboard-input/2506326
- CD Draw text UI (Can be easily replaced) https://forum.cfx.re/t/free-release-draw-text-ui/1885313

## Conflicts

- esx_skin
- skinchanger
This rescorce is meant to replace these two so it cannot be used while these rescorces are running 

## Setup

You must trigger this export client side after the player loads in order to set their skin 

```cfg
ESX.TriggerServerCallback('fivem-appearance:getPlayerSkin', function(appearance)
    exports['fivem-appearance']:setPlayerAppearance(appearance)
end)
```

## Server Config

```cfg
ensure fivem-appearance
setr fivem-appearance:locale "en"
```

## Preview

![](https://i.imgur.com/Cs1fvNC.jpeg"")
![](https://i.imgur.com/sA55YgF.jpeg"")
![](https://i.imgur.com/dR3U3Uu.jpeg"")
![](https://i.imgur.com/hyhXldt.jpeg"")
![](https://i.imgur.com/ACKPHv3.jpeg"")

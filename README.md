
To use the character.blend files for player/zombie, you will need [this](https://extensions.blender.org/add-ons/sprite-sheet-maker/) blender addon with these settings to make a proper sprite. 
- Example - Player sprite
	![[Pasted image 20260514180856.png]]
You can use the example texture in `textres/Player/alpha_mask_clean` to make a custom texture. Loading it through blender and rendering it through the sprite sheet addon will spit out a spritesheet perfect for the game. I would suggest keeping each player sprite texture rendered at 512x512, but if you have the pixel filter on it will still look really choppy, so do be warned.
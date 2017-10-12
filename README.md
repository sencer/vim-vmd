# A VMD plugin for Neovim

A plugin to use VIM+VMD as a molecular editor.

Run `:VMD` to spawn a VMD instance and to reload the file in it when you 
make changes --- or try using `au BufWritePost <buffer> VMD`

Pick an atom from VMD to find it in VIM buffer, or shift+pick to 
highlight multiple.

There is also a `:FromVMD` to load XYZ coordinates from VMD back to VIM 
buffer, if any change made in VMD -but it uses a `save_xyz` proc from my 
VMD settings. Quite simple to implement though. I didn't bother as I made 
this for personal use.

Finally watch the screencast to see it in action:

[![Screencast](https://img.youtube.com/vi/snxHKbumtYY/0.jpg)](https://youtu.be/snxHKbumtYY)

( The visual atom selection in VMD is also from my own scripts, you don't 
get this visual feedback when you use this plugin only.)

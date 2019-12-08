# git_profile
# Disclaimer
Many of these functions are untested and may not work under all (or any) edge cases. So I guess use at your own risk or something.

# Setup
There's a bit of setup required to get everything working right, and I'm still in the process of streamlining and documenting those steps. So following these next steps should get you most of the way there, but if you're looking for a more hassle-free experience, I would recommend picking and choosing the functions that seem useful to you and copy-pasta'ing them into your own profile.

## Environment
The Environment Configuration section in 'bash_profile' needs to set up according to your own environment. For MacOs, the system defaults to pulling profile information from '~', so it's preferable to move all files there with a hidden, '.', prefix (e.g. ~/.bash_profile).

## ZSH
Completions (and by that I mean tab-completions) aren't currently set up properly for bash (at least, I haven't tested if they work or not). So you might need to switch over to zsh (which is what I use) if you want to take full advantage of those. I personally use a modded 'Oh My Zsh' setup, but the completions should work fine with any zsh setup. 

If you want to set up Oh My Zsh, you can check it out here: https://github.com/ohmyzsh/ohmyzsh

## fuzzy finder (FZF)
My life changed forever when I found out about fzf. And I hope it will change your life as well. Regardless of whether you want to use any part of my profile or not, install it NOW. 

Here's the link: https://github.com/junegunn/fzf

## ripgrep (RG)
For the majority of cases, grep will do you just fine. But if you want to be a 10X engineer, at some point you just need to do things _faster_. That's exactly what ripgrep does. 

Check it out: https://github.com/BurntSushi/ripgrep

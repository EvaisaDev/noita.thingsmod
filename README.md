The point of this project is to cooperatively extend Noita with content.
   
Everyone is free to add whatever the hell you want, feel free to make a pull request.  
It will likely be accepted as long as it is not broken and somewhat fits noita as a whole. We do not intend to make the game unplayable.
This is intended to be something the average Noita player can enjoy.
There is a thread for discussing it on the Noita Discord.

### Installation

- Press the [Download](https://github.com/EvaisaDev/noita.thingsmod/archive/refs/heads/main.zip) button
- Extract the contents into your Noita `mods` folder.
- Rename the folder from `noita.thingsmod-main` to `noita.thingsmod`.

Alternatively, subscribe to the mod on the Steam Workshop once it is available.

### Development

In order to develop the mod you will need to clone it.

```sh
git clone https://github.com/EvaisaDev/noita.thingsmod.git
```

Next you need to initialise submodules (the libraries used by the mod)

```sh
cd noita.thingsmod
git submodule update --init --recursive
```

To create a feature create a feature branch to work on

```sh
git switch -c my_awesome_feature
```

Make a new module for your content and commit it

```sh
mkdir content/some_module
echo "return {}" > content/some_module/module.lua
sed -i 's/}/\t"some_module",\n}/' content.lua
git add .
git commit -m "Add some module"
```

Create a fork (on GitHub) and push to it

```sh
git remote rename origin upstream
git remote add origin https://github.com/"YourUser"/noita.thingsmod.git
git push -u origin my_awesome_feature
```

Create a pull request on GitHub and wait for it to be merged

Meadow Login Screen for Kedos
=============

Simple, sleek, and lightweight login screen designed for Kedos Operating System.

Meadow, in technical terms is a LightDM login screen. It is built on top of Acis framework.

Note: Although Meadow is designed for Kedos, it is still installable on other distros.

Building
-----------

You need Acis, LightDM, LightDM lib, and other components.
After installing required libraries, cd into the meadow folder, then:

```
mkdir build
cd build
cmake ..
sudo make install
./meadow (for testing)
```

Installing
-----------

Simply run:
```
sudo bash -c 'echo "greeter-session=meadow" >> /etc/lightdm/lightdm.conf'
```

Uninstalling
-----------

Remove 'meadow' from 'greeter-session' in /etc/lightdm/lightdm.conf.

Caution: Remember, if you don't have any other login screens, LightDM will fail.

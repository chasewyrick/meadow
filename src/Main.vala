//  
//  Copyright (C) 2012-2017 Abraham Masri
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
// 

using Acis;
using Meadow.OnScreen;

namespace Meadow {

    LightDM.Greeter _Greeter;
    public LockWindow _LockWindow;
    public UserControl _UserControl;

    public static void main (string [] args) {

        PrintWelcome("Meadow Greeter", COLOR.White);

        Gtk.init (ref args);

        _Greeter = new LightDM.Greeter ();


        _LockWindow = new LockWindow();
        _LockWindow.FadeIn();

        /* Set default session */
        CurrentSession = "gnome";

        /* Protect memory from being paged to disk, as we deal with passwords */
        Posix.mlockall (Posix.MCL_CURRENT | Posix.MCL_FUTURE);

        /* Set up the accessibility stack, in case the user needs it for screen reading etc. */
        Environment.set_variable ("GTK_MODULES", "atk-bridge", false);

        var main_settings = Gtk.Settings.get_default ();
        main_settings.set("gtk-xft-dpi", (int) (1042 * 100), null);
        main_settings.set("gtk-xft-antialias", 1, null);
        main_settings.set("gtk-xft-rgba" , "rgba", null);

        /* Set the cursor to not be the crap default */
        Gdk.get_default_root_window ().set_cursor (new Gdk.Cursor (Gdk.CursorType.LEFT_PTR));

        GtkMain ();


    }
}

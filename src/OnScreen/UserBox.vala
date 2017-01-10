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

using Gtk;
using GLib.Environment;

namespace Meadow {

    public class User : EventBox {

        // Holds all widgets. Main child of this
        public Box mainContainer = new Box(Orientation.VERTICAL, 5);

        // Holds the user picture
        public Fixed Container = new Fixed();
        public Image Window;
        private Button button = new Button();
        public Image usrpic = new Image();
        public Image usrpicshadow;
        public Label usrname = new Label(null);
        public LightDM.User _User;

        int ScreenHeight = Gdk.Screen.height();
        int ScreenWidth  = Gdk.Screen.width();

        string CSS = "*, *:insensitive {
                         transition: 150ms ease-in;
                         background-color: rgba(255, 255, 255, 0.9);
                         border-radius: 4px;
                         box-shadow: 0 0 5px rgba(0, 0, 0, 0.5);
                         border-width: 0px;
                         padding: 0px;
                         }
                        *:hover {
                         transition: 150ms ease-out;

                         box-shadow: 0 0 5px rgba(0, 0, 0, 0.7);

                        }
                        *:active {
                         transition: 150ms ease-out;

                         box-shadow: 0 0 5px rgba(0, 0, 0, 0.9);

                        }

                         ";


        public User (LightDM.User _User) {

            this._User = _User;
            margin = 30;
            mainContainer.add_events(Gdk.EventMask.BUTTON_PRESS_MASK |
                       Gdk.EventMask.POINTER_MOTION_MASK |
                       Gdk.EventMask.ENTER_NOTIFY_MASK |
                       Gdk.EventMask.LEAVE_NOTIFY_MASK);


            /* Setup */
            Window = new Image.from_file("/System/Resources/Meadow/user-box.svg");
            usrpicshadow = new Image.from_file("/System/Resources/Meadow/user-box-shadow.svg");



            /* Apply properties */
            SetLabel(_User.real_name);
            Acis.ApplyCSS({mainContainer, button}, CSS);

            usrpic.set_from_pixbuf(new Gdk.Pixbuf.from_file_at_scale(_User.image, 96, 96, false));


            button.margin = 7;
            mainContainer.margin = 10;
            button.margin_bottom = 5;
            usrname.margin_bottom = 10;


            // Add widgets
            button.add(usrpic);
            mainContainer.add(button);
            mainContainer.add(usrname);
            // mainContainer.add(_Stack);
            add(mainContainer);


            button_release_event.connect ((e) => {

                _LockWindow.showSelectedUserBox(_User);


                return false;
            });


            button.key_release_event.connect ((e) => {

                _LockWindow.showSelectedUserBox(_User);


                return false;
            });




        }



        /* Set the label with markup */
        public void SetLabel(string text, string color = "black") {


            usrname.halign = Align.CENTER;
            usrname.set_markup(@"<span color='$color' font='OpenSans Semibold 9'>$text</span>");

        }
    }
}

//
//  Copyright (C) 2011-2017 Abraham Masri
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

namespace Meadow {

    public class SessionOption : Button {

        /* Add some style */
        string CSS = "*{
                         background-color: rgba(255, 255, 255, 0.3);

                         background-image: none;
                         border: none;
                         border-color: @transparent;
                         color: black;
                         text-shadow:0px 0px 0px rgba(0, 0, 0, 0.0);
                         icon-shadow: 0px 1px 4px rgba(0, 0, 0, 0.4);

                       }

                       *:hover {
                         background-color: @transparent;

                         border-style: outset;

                        }";


        /* Signals */
        public signal void Changed ();

        public SessionOption (LightDM.Session _Session) {

            margin = 3;

            /* Option title */
        	var Title = new Label(_Session.name);
            Acis.ApplyCSS({this}, CSS);

            button_press_event.connect((e) => {

                _LockWindow._OptionsSack.Hide();
                CurrentSession = _Session.key;
                _UserControl.SetContents();
                Changed();

                return false;
            });

        	add(Title);

        }
    }

}

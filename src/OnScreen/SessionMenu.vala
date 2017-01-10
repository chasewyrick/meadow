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
using Gdk;
using GLib.Environment;

namespace Meadow {

    public class SessionMenu : EventBox {

        /* Add some style */
        string CSS = "*, *:insensitive {
                         background-color: @transparent;
                         background-image: none;
                         border: none;
                         border-color: @transparent;
                         box-shadow: inset 1px 2px rgba(0,0,0,0); 
                         border-radius: 15px;
                         color: white;
                         font:10px DroidSans;
                       }

                       *:hover, *:insensitive {
                         transition: 50ms ease-out;
                         border-style: outset;


                        }";

        /* The button */
        public Button _Button = new Button();

        /* Holder */
        public Box _Box = new Box(Orientation.VERTICAL, 0);

        /* Animator */
        Stack _Stack = new Stack();

        /* Button icons */
        Image Normal = new Image.from_file("/System/Resources/Meadow/menu.svg");
        Image Hover = new Image.from_file("/System/Resources/Meadow/hover.svg");

        construct {

            add_events(EventMask.BUTTON_PRESS_MASK);
            set_halign(Align.END);
            set_valign(Align.CENTER);
            margin = 15;

            add(_Box);


        }

        public SessionMenu () {

            Acis.ApplyCSS({_Button}, CSS);

            _Stack.add_named(Normal, "Normal");
            _Stack.add_named(Hover, "Hover");
    

            /* Set some options */
            _Stack.set_transition_duration(450);
            _Stack.set_transition_type(StackTransitionType.CROSSFADE);
            _Stack.set_visible_child_name("Normal");

            _Box.add(_Stack);


            /* Signals */
            enter_notify_event.connect(() => {

                ToggleOptions();

                return false;
            });

            leave_notify_event.connect(() => {

                ToggleOptions();

                return false;
            });

        }

        /* Toggle icon's options */
        public void ToggleOptions () {


            if(_Stack.get_visible_child_name() == "Normal")
                _Stack.set_visible_child_name("Hover");
            else
                _Stack.set_visible_child_name("Normal");

        }
    }
}

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

namespace Meadow {

    public class OptionsSack : Stack {

        /* Options holder */
        public Box Holder = new Box(Orientation.VERTICAL, 0);

        /* Toggle shown */
        public bool Shown = false;

        public OptionsSack () {

            /* Add an empty widget */
            add_named(new Grid(), "Empty");    

            /* Add the holder */
            add_named(Holder, "Holder");    

            /* Options */
            set_transition_duration(250);
            set_transition_type(StackTransitionType.CROSSFADE);
            set_visible_child_name("Empty");

        }

        /* Show the options */
        public void Show() {

            set_visible_child_name("Holder");
            Shown = true;
        }

        /* Hides the options */
        public void Hide() {

            set_visible_child_name("Empty");
            Shown = false;
        }
    }
}

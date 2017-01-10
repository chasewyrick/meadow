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
using Acis;
using Cairo;
using Acis.SysInfo;

namespace Meadow.OnScreen {

    public class PowerBox : Gtk.Box {


        /* Power Options */
        PowerOption Shutdown;
        PowerOption Reboot;
        PowerOption Suspend;

    	public PowerBox () {

    		set_orientation(Orientation.HORIZONTAL);
            halign = Align.CENTER;

            margin_bottom = 20;

            /* Initialize Widgets */
            Shutdown  = new PowerOption("Shutdown");
            Reboot  = new PowerOption("Reboot");
            Suspend  = new PowerOption("Suspend");



            add(Shutdown);
            add(Reboot);
            add(Suspend);

    	}

    }

}
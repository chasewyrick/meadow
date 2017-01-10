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
using LightDM;
using Acis;

namespace Meadow.OnScreen {

	/* Power Option Button */
    public class PowerOption : EventBox {

        string Normal = "";
        string Hovered = "";
        string Clicked = "";
        string HoverLabel = "";
        public PowerOption (string Type) {

            if(Type == "Shutdown") {
                Normal = "/System/Resources/Meadow/system-shutdown.svg";
                Hovered = "/System/Resources/Meadow/system-shutdown-hover.svg";
                Clicked = "/System/Resources/Meadow/system-shutdown-click.svg";
                HoverLabel = "Shutdown";
            } else if(Type == "Reboot") {
                Normal = "/System/Resources/Meadow/system-reboot.svg";
                Hovered = "/System/Resources/Meadow/system-reboot-hover.svg";
                Clicked = "/System/Resources/Meadow/system-reboot-click.svg";
                HoverLabel = "Reboot";
            } else if(Type == "Suspend") {
                Normal = "/System/Resources/Meadow/system-suspend.svg";
                Hovered = "/System/Resources/Meadow/system-suspend-hover.svg";
                Clicked = "/System/Resources/Meadow/system-suspend-click.svg";
                HoverLabel = "Suspend";
            } else if(Type == "Hibernate") {
                Normal = "/System/Resources/Meadow/system-hibernate.svg";
                Hovered = "/System/Resources/Meadow/system-hibernate-hover.svg";
                Clicked = "/System/Resources/Meadow/system-hibernate-click.svg";
                HoverLabel = "Hibernate";
            }




            var iOption = new Image.from_file(Normal);
            add(iOption);
            Acis.AddAlpha({this, iOption});
            Acis.ApplyCSS({this, iOption}, "*{background-color: rgba(0,0,0,0.0);}");
            margin = 10;


            enter_notify_event.connect(() => {

                iOption.set_from_file(Hovered);

                return true;
            });

            leave_notify_event.connect(() => {

                iOption.set_from_file(Normal);

                return true;
            });

            button_press_event.connect(() => {

                iOption.set_from_file(Clicked);

                return true;
            });

            button_release_event.connect(() => {

                iOption.set_from_file(Normal);

                if(Type == "Suspend") {


                    FadeWindow({_LockWindow}, 30, false, (() => { 
                    
                        suspend();
                        Timeout.add(4000, () => {

                            FadeWindow({_LockWindow}, 30, true, (() => {})); 
                            
                            return false;
                        });
                    }));


                } else if(Type == "Shutdown") {


                    FadeWindow({_LockWindow}, 30, false, (() => { 
                    
                        shutdown();
                    
                    }));

                } else if(Type == "Reboot") {

                    FadeWindow({_LockWindow}, 30, false, (() => { 
                    
                        restart();
                    
                    }));

                }



                return true;
            });

        }

    }
}
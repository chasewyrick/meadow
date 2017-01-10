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

    public class SelectedUserBox : Gtk.Box {

        // User Box
        User user;

        // Contains Password entry and login button
        public Box verticalBox = new Box(Orientation.VERTICAL, 10);


        // Password Entry
        public Acis.Widgets.Entry passcode = new Acis.Widgets.Entry();


        // Try again label + Revealer
        private Revealer tryAgainRevealer = new Revealer();
        private Label tryAgainLabel = new Label(null);

        // Back button (contains image and label)
        private Button backButton = new Button();
        private Box backBox = new Box(Orientation.HORIZONTAL, 5);
        private Image backImage = new Image.from_file("/System/Resources/Meadow/back-arrow.svg");
        private Label backLabel = new Label("Back");

        string CSS = "*, *:insensitive {
                         transition: 150ms ease-in;
                         background-color: rgba(255, 255, 255, 0.0);
                         color: white;
                         border-radius: 20px;
                         box-shadow: 0 0 5px rgba(0, 0, 0, 0.0);
                         border-width: 0px;
                         padding: 10px;
                         text-shadow: none;
                         background-image: none;
                         border: @none;

                         }
                        *:hover {
                         transition: 150ms ease-out;

                         background-color: rgba(0, 0, 0, 0.05);
                         

                        }
                        *:active {
                         transition: 150ms ease-out;

                         box-shadow: 0 0 5px rgba(0, 0, 0, 0.4);

                        }

                         ";


        string passcodeCSS = "*{ background-color: rgba(255, 255, 255, 0.4); color:white; border-width: 0px; border-radius:4px;
                         background-image: none; 
                         border-image: none;
                         box-shadow: none;
                         font: 16px;
                         }";

    	public SelectedUserBox () {


            // Properties
    		set_orientation(Orientation.HORIZONTAL);
            Acis.ApplyCSS({backButton}, CSS);
            passcode.SetType(Acis.Widgets.EntryType.PASSWORD, "Passcode");
            Acis.ApplyCSS({passcode.entry}, passcodeCSS);
            Acis.AddAlpha({backButton});

            passcode.entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "go-jump-symbolic");
            tryAgainLabel.set_markup("<span color='white' font='Droid Sans 9'>Wrong Passcode</span>");

            verticalBox.halign = Align.START;
            verticalBox.valign = Align.CENTER;
            backButton.halign = Align.START;
            backButton.valign = Align.CENTER;

            backButton.margin = 5;

            // Actions
            passcode.entry.icon_press.connect ((pos, event) => {
                if (pos == Gtk.EntryIconPosition.SECONDARY) {

                    _LockWindow.showLoadingIndicator();
                    _Greeter.authenticate (passcode.entry.text);
                }
            });


            passcode.entry.key_press_event.connect ((e) => {

                switch (e.keyval) {

                    case Gdk.Key.Return:
                    case Gdk.Key.KP_Enter:
                        _Greeter.authenticate (user._User.name);
                        _LockWindow.showLoadingIndicator();
                        
                        break;  

                    case Gdk.Key.Menu:
                        passcode.Focus();
                        break;

                        
                }
            
                   return false;

            });


            backButton.button_release_event.connect (() => {


                _LockWindow.hideSelectedUserBox();
                return true;
            });


            /* Wrong passcode */
            _Greeter.show_message.connect(() => {
                
                _LockWindow.showSelectedUserBox(user._User);
                tryAgainRevealer.set_reveal_child(true);
                passcode.Clear();
            });


            _Greeter.show_prompt.connect(() => {
                _Greeter.respond (passcode.entry.text);
 
            });

            _Greeter.authentication_complete.connect(() => {
                if (_Greeter.is_authenticated) {

                    /* Hide everything except the Background */
                    _LockWindow.FadeOut();

                } else {
                    
                    _LockWindow.showSelectedUserBox(user._User);
                    tryAgainRevealer.set_reveal_child(true);
                }

            });

            // Add widgets
            backBox.add(backImage);

            tryAgainRevealer.add(tryAgainLabel);
            backButton.add(backBox);
            verticalBox.add(passcode);
            verticalBox.add(tryAgainRevealer);




    	}


        /* Set the selected user (called when user clicks on one of the users) */
        public void setUser (LightDM.User lightDMuser){

            // Remove all children first
            foreach(var child in get_children())
                remove(child);

            this.user = new User(lightDMuser);

            // this.user.margin = 2;
            pack_start(backButton);
            pack_start(this.user, false, false);
            pack_start(verticalBox);

            this.show_all();
            passcode.Focus();

        }

    }

}
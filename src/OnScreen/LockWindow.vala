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
using LightDM;


namespace Meadow.OnScreen {

  public class LockWindow : Gtk.Window {
   
        // Fixed holds everything
        public Fixed _Fixed = new Fixed();

        // The widgets container
        public Box Container = new Box(Orientation.VERTICAL, 0);

        // Contains time and session
        public Box TopPanel = new Box(Orientation.HORIZONTAL, 0);

        // Sessions */
        public OptionsSack _OptionsSack = new OptionsSack();

        // Users grid stack
        public Stack usersStack = new Stack();

        // Users grid
        public Widgets.Grid _Grid = new Widgets.Grid();

        // Selected User Box 
        public SelectedUserBox selectedUserBox = new SelectedUserBox();

        // Screen resolution
        unowned int sheight = Gdk.Screen.get_default().height();
        unowned int swidth =  Gdk.Screen.get_default().width();

        // List of users available
        public UserList _UserList = UserList.get_instance ();

        // Drawing utility from Acis
        Acis.CairoMethods? main_buffer = null;

        // Options button to change the session
        Widgets.OptionsButton _OptionsButton = new Widgets.OptionsButton();

        // Pops up when you tap OptionsButton
        public Gtk.Popover _Popover = null;

        // Revealer holds powerbox
        Revealer powerBoxRevealer = new Revealer();

        // Spinner shown when authenticating
        Spinner authentiatingSpinner = new Spinner();

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


        public LockWindow () {

            /* Options */
            set_keep_above(true);
            app_paintable = false;
            skip_pager_hint = true;
            skip_taskbar_hint = true;
            stick ();
            decorated = false;
            Acis.AddAlpha({this});
            Acis.ApplyCSS({this}, "*{background-color: rgba(0,0,0,0.0);}");
            opacity = 0.0;

            _UserControl = new UserControl();


            _Greeter.connect_sync ();
            resize(swidth, sheight);
            grab_focus();

            authentiatingSpinner.active = true;
            authentiatingSpinner.halign = Align.CENTER;
            authentiatingSpinner.valign = Align.CENTER;

            usersStack.set_transition_duration(500);
            usersStack.set_transition_type(StackTransitionType.UNDER_UP);
            usersStack.halign = Align.CENTER;
            usersStack.valign = Align.START;


            Sessions = new List<LightDM.Session>();


            /* Add sessions to session list */
            foreach(var _Session in get_sessions())
                Sessions.append(_Session);


            /* Sessions menu & Options */
            _Popover = new Gtk.Popover(_OptionsButton);

            /* Signals */
            _OptionsButton.button_press_event.connect((e) => {

                _LockWindow._Popover.show_all();

                _OptionsButton.ToggleOptions();


                return false;
            });



            TopPanel.hexpand = true;
            Container.hexpand = true;

            _Grid.EdgeLimit = 5;
            _Grid.halign = Align.CENTER;
            _Grid.valign = Align.START;

            TopPanel.pack_start(new Widgets.TimeBox());

            if(Sessions.length() > 1)
                TopPanel.pack_end(_OptionsButton);



            // Add widgets
            Container.add(TopPanel);

            AddSessions();

            /* Check Users and append them */
            foreach(var _User in _UserList.users)
                _Grid.append(new User(_User));


            usersStack.add_named(_Grid, "grid");
            usersStack.add_named(selectedUserBox, "selectedUserBox");
            usersStack.add_named(authentiatingSpinner, "spinner");

            usersStack.set_visible_child_name("grid");

            powerBoxRevealer.add(new PowerBox());

            Container.pack_start(new Label(null), true, false);
            Container.pack_start(usersStack);
            Container.pack_end(powerBoxRevealer, false, false);



            add(Container);

            draw.connect((cr) => {

                cr.set_source_surface(main_buffer.surface, 0,0);    
                cr.paint();
                
                return false;
            });



        }

        /* Adds sessions to the popover */
        void AddSessions () {

            var SessionsBox = new Box(Orientation.VERTICAL, 0);
            foreach(var Session in Sessions) {
                var _SessionOption = new SessionOption(Session); 
                _SessionOption.Changed.connect(() => {
                    _Popover.hide();
                    _OptionsButton.ToggleOptions();
                });

                SessionsBox.add(_SessionOption);

            }

            _Popover.add(SessionsBox);

        }

        /* Fades in the window */
        public void FadeIn () {

            swidth = Gdk.Screen.width();
            sheight = Gdk.Screen.height();

            // Get User's wallpaper/background
            File UserDir = File.new_for_path(@"/home/$(_UserList.users.nth_data(0).name)/.User/");
            File BackgroundFile = UserDir.get_child("Background.prop");

            string backgroundLocation = null;

            var backgroundKeyfile = new KeyFile();

            backgroundKeyfile.load_from_file(BackgroundFile.get_path(), 0);
            backgroundLocation = backgroundKeyfile.get_string("UserPreferences", "BackgroundPath");

            // Check if background exists and if valid
            var backgroundFile = File.new_for_path(backgroundLocation);

            if(!backgroundFile.query_exists() || (backgroundFile.query_info("standard::*", FileQueryInfoFlags.NONE).get_size() == 0)) {

                // Set background to default (TODO: Change me after building the wallpapers pkg)
                backgroundLocation = "/System/Resources/Meadow/default-background.jpg";

            }

            var _Background = new Pixbuf.from_file(backgroundLocation);
            _Background = ImageTools.ScaleToFit(_Background, swidth, sheight);

            main_buffer = new Acis.CairoMethods (swidth, sheight);
            cairo_set_source_pixbuf (main_buffer.context, Utilites.Darken(Utilites.Blur(Utilites.Blur(_Background, 30), 30), 255, 150), 0, 0);
            main_buffer.context.paint();

            resize(swidth, sheight);

            opacity = 0;
            show_all();
                
            Acis.FadeWindow({this}, 10, true, () => {

                powerBoxRevealer.set_reveal_child(true);

                });


        }

        /* Fades out the window */
        public bool FadeOut () {

            FadeWindow({this}, 30, false, (() => { 
                hide();
                _Greeter.start_session_sync (CurrentSession);

            }));

            return false;
        }


        /* Shows the loading indicator */
        public void showLoadingIndicator () {

            usersStack.set_transition_type(StackTransitionType.CROSSFADE);
            usersStack.set_visible_child_name("spinner");
            powerBoxRevealer.set_reveal_child(false);



        }

        /* Shows the selected user box */
        public void showSelectedUserBox (LightDM.User _User) {

            usersStack.set_transition_type(StackTransitionType.SLIDE_LEFT);
            selectedUserBox.setUser(_User);
            usersStack.set_visible_child_name("selectedUserBox");
            powerBoxRevealer.set_reveal_child(true);



        }

        /* Hides the selected user box */
        public void hideSelectedUserBox () {

            usersStack.set_transition_type(StackTransitionType.SLIDE_RIGHT);
            usersStack.set_visible_child_name("grid");



        }
    }
}

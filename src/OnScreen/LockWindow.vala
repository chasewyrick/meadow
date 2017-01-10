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
   
        /* Fixed holds everything */
        public Fixed _Fixed = new Fixed();

        /* The widgets container */
        public Box Container = new Box(Orientation.VERTICAL, 0);

        /* Contains time and session */
        public Box TopPanel = new Box(Orientation.HORIZONTAL, 0);

        /* Sessions */
        public OptionsSack _OptionsSack = new OptionsSack();

        /* Users grid stack */
        public Stack stack = new Stack();

        /* Users grid */
        public Widgets.Grid _Grid = new Widgets.Grid();

        /* Selected User Box */
        public SelectedUserBox selectedUserBox = new SelectedUserBox();

        /* Login with cloud button */
        private Button cloudButton = new Button();


        /* Screen resolution */
        unowned int sheight = Gdk.Screen.get_default().height();
        unowned int swidth =  Gdk.Screen.get_default().width();

        /* List of users available */
        public UserList _UserList = UserList.get_instance ();

        /* Drawing utility from Acis */
        Acis.CairoMethods? main_buffer = null;

        public Gtk.Popover _Popover = null;

        /* Options button to change the session */
        Widgets.OptionsButton _OptionsButton = new Widgets.OptionsButton();

        /* Revealer holds powerbox */
        Revealer revealer = new Revealer();


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
            Acis.ApplyCSS({this, _Popover}, "*{background-color: rgba(0,0,0,0.0);}");
            Acis.ApplyCSS({cloudButton}, CSS);
            opacity = 0.0;

            _UserControl = new UserControl();


            _Greeter.connect_sync ();
            resize(swidth, sheight);
            grab_focus();

            stack.set_transition_duration(500);
            stack.set_transition_type(StackTransitionType.UNDER_UP);
            stack.halign = Align.CENTER;
            stack.valign = Align.START;

            cloudButton.margin = 5;


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

            // // Add the cloud
            // var cloudBox = new Box(Orientation.VERTICAL, 10);
            // cloudBox.add(new Image.from_file("/System/Resources/Meadow/cloud-login.svg"));
            // cloudBox.add(new Label("Cloud Login"));
            // cloudButton.valign = Align.CENTER;
            // cloudButton.add(cloudBox);
            // _Grid.append(cloudButton);


            stack.add_named(_Grid, "grid");
            stack.add_named(selectedUserBox, "selectedUserBox");
            stack.set_visible_child_name("grid");

            revealer.add(new PowerBox());

            Container.pack_start(new Label(null), true, false);
            Container.pack_start(stack);
            Container.pack_end(revealer, false, false);



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

            string BackgroundLocation = null;

            var BackgroundKeyfile = new KeyFile();

            BackgroundKeyfile.load_from_file(BackgroundFile.get_path(), 0);
            BackgroundLocation = BackgroundKeyfile.get_string("UserPreferences", "BackgroundPath");

            var _Background = new Pixbuf.from_file(BackgroundLocation);
            _Background = ImageTools.ScaleToFit(_Background, swidth, sheight);

            main_buffer = new Acis.CairoMethods (swidth, sheight);
            cairo_set_source_pixbuf (main_buffer.context, Utilites.Darken(Utilites.Blur(Utilites.Blur(Utilites.Blur(_Background, 30), 30), 30), 255, 150), 0, 0);
            main_buffer.context.paint();

            resize(swidth, sheight);

            opacity = 0;
            show_all();
                
            Acis.FadeWindow({this}, 10, true, () => {

                revealer.set_reveal_child(true);

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


        /* Shows the selected user box */
        public void showSelectedUserBox (LightDM.User _User) {

            stack.set_transition_type(StackTransitionType.SLIDE_LEFT);
            selectedUserBox.setUser(_User);
            stack.set_visible_child_name("selectedUserBox");



        }

        /* Hides the selected user box */
        public void hideSelectedUserBox () {

            stack.set_transition_type(StackTransitionType.SLIDE_RIGHT);
            stack.set_visible_child_name("grid");



        }
    }
}

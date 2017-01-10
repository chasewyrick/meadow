//  
//  Copyright (C) 2012-2014 Abraham Masri
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

namespace Meadow {

    /* Current chosen session */
    public string CurrentSession = null;

    /* Sessions list */
    public List<LightDM.Session> Sessions;


    public class UserControl : Object {

        private File MeadowFolder = File.new_for_path("/System/Library/Meadow/");
        private File SettingsFile;

        public KeyFile Settings = new KeyFile();

        /* Group name */
        public string Group = "MeadowPreferences";

        public UserControl () {

            SettingsFile = MeadowFolder.get_child("Settings.prop");

            CheckExists();

            Settings.load_from_file(SettingsFile.get_path(), 0);

            ReadContents();

        }

        /* Make sure that files exist */
        public void CheckExists () {

            if(!MeadowFolder.query_exists())
                MeadowFolder.make_directory();

            if(!SettingsFile.query_exists()) {

                /* Setup Keyfiles */
                Settings.set_string(Group, "Session", "kedos");

                /* Save Settings.prop */
                var Stream = new DataOutputStream (SettingsFile.create (0));
                Stream.put_string (Settings.to_data());
                Stream.close ();


            }
        }

        /* Check for contents */
        public void ReadContents () {

            CurrentSession = Settings.get_string(Group, "Session");

        }

        /* Set contents */
        public void SetContents () {

            /* Update settings */
            Settings.set_string(Group, "Session", CurrentSession);
            FileUtils.set_contents(SettingsFile.get_path(), Settings.to_data());

        }

    }
}

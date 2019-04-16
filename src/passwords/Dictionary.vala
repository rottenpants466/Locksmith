/*
* Copyright (C) 2019  Christopher Nugent <awedeven+elementarydev@gmail.com>
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using Gee;      // for the List data structure

namespace App.Passwords {

    public class Dictionary : Object {

        private const string DICTIONARY_RESOURCE_URI = "resource:///data/words_alpha.txt";

        private Gee.List<string> words { get; default = new ArrayList<string> (); }

        public Dictionary.from_builtin_dictionary () {
            try {
                var dictionary_file = File.new_for_uri (DICTIONARY_RESOURCE_URI);
                var dis = new DataInputStream (dictionary_file.read ());
                // Parse the input by line, quit when the line is null
                string line;
                while ((line = dis.read_line (null)) != null) {
                    // strip whitespace to remove the trailing newline
                    // make lowercase for consistency
                    words.add (line.strip ().down ());
                }
                message("Loaded dictionary resource. Words: %d".printf(words.size));
            } catch (Error e) {
                error("Could not load dictionary resource.");
            }
        }

        public string get_random_word () {
            var random_index = Random.int_range (0, words.size);
            return words[random_index];
        }
    }
}

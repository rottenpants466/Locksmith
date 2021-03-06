/*
* Copyright (C) 2018  Christopher Nugent <awedeven+elementarydev@gmail.com>
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

using Gtk;
using App.Passwords;
using App.Configs;

namespace App.Views {

    public abstract class PasswordView : Grid {

        protected PasswordGenerator password_generator;
        protected App.Configs.Settings settings;

        private Entry password_text;
        private SpinButton password_length_entry;

        protected string password {
            get { return password_text.text; }
            set { password_text.text = value; }
        }

        protected int password_length { 
            get { return (int) password_length_entry.value; }
            set { password_length_entry.value = value; }
        }

        protected int max_length {
            set { password_length_entry.adjustment.upper = value; }
        }

        protected int length_step {
            set { password_length_entry.adjustment.step_increment = value;}
        }

        public PasswordView (PasswordGenerator password_generator) {
            this.password_generator = password_generator;
            settings = App.Configs.Settings.get_instance ();
            margin = 12;
            row_spacing = 18;
            create_password_text ();
            create_password_length_entry ();
            create_buttons();
        }

        private void create_password_text () {
            password_text = new Entry ();
            password_text.max_width_chars = 64;
            password_text.editable = false;
            attach (password_text, 0, 0);
        }
        private void create_password_length_entry () {
            var box = new Box (Orientation.HORIZONTAL, 12);
            box.halign = Align.CENTER;
            var label = new Label (_("Password Length"));
            password_length_entry = new SpinButton.with_range (0, 512, 64);
            password_length_entry.hexpand = false;
            password_length_entry.value_changed.connect (() => {
                save_password_length (password_length);
            });
            box.add (label);
            box.add (password_length_entry);

            attach (box, 0, 1);
        }


        private void create_buttons () {
            var box = new Box(Orientation.HORIZONTAL, 12);
            box.halign = Align.END;
            box.valign = Align.END;

            var button_generate_password = create_generate_button ();
            var button_copy_password = create_clipboard_button ();

            box.add (button_copy_password);
            box.add (button_generate_password);
            attach (box, 0, 5);   

        }

        private Button create_generate_button () {
            var button_generate_password = new Button.with_label (_("Generate Password"));
            button_generate_password.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            button_generate_password.clicked.connect (() => {
                generate_password ();
            });
            return button_generate_password;
        }

        private Button create_clipboard_button () {
            var button_copy_password = new Button.with_label (_("Copy to Clipboard"));
            button_copy_password.clicked.connect (() => {
                save_password_to_clipboard ();
            });
            return button_copy_password;
        }

        private void save_password_to_clipboard () {
            var clipboard = Clipboard.get_default (get_display ());
            clipboard.set_text (password, -1);
        }

        protected abstract void generate_password ();
        protected abstract void save_password_length (int length);
    }
}

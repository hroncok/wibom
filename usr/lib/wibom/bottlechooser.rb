#!/usr/bin/ruby
# wibom script to choose a bottle from wibom-bottle-chooser
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2010, Miro Hrončok [hroncok.cz]
require 'gtk2'
require 'gettext'
include GetText
bindtextdomain("wibom-gtk")

exitus = 1 # If it end in the middle, something went wrong
@libdir = File.dirname(__FILE__)

# Choose a Wine bottle

bottlelistlabel = Gtk::Label.new(_("Choose a Wine bottle, where the selected Windows application should be run:"))
bottlelist = Gtk::ComboBox.new(is_text_only = true)
# Default bottle
bottlelist.append_text(`echo $HOME/.local/share/bottles/default`.chomp)
# Other bottles
file = File.new(`echo $HOME/.local/share/bottles/bottles.lst`.chomp, "r")
while (line = file.gets)
	bottlelist.append_text(line.chomp)
end
file.close
bottlelist.active = 0

# Or create new bottle
newbottleexpander = Gtk::Expander.new(_("Create a _new bottle"), true)

newbottletoggle = Gtk::CheckButton.new(_("Run the selected Windows application in a  new _bottle"))
clonebottletoggle = Gtk::CheckButton.new(_("_Clone an existing (above selected) bottle to the new one"))
clonebottletoggle.sensitive = FALSE

# Visibility of some widgets
newbottletoggle.signal_connect("toggled") {
	clonebottletoggle.sensitive = newbottletoggle.active?
	if !clonebottletoggle.active?
		bottlelist.sensitive = !newbottletoggle.active?
	end
}
clonebottletoggle.signal_connect("toggled") {
	bottlelist.sensitive = clonebottletoggle.active?
}

newbottlevbox = Gtk::VBox.new(false,5)
newbottlevbox.pack_start_defaults(newbottletoggle)
newbottlevbox.pack_start_defaults(clonebottletoggle)

newbottleexpander.add(newbottlevbox, nil)

# Buttons

cancelbutton = Gtk::Button.new(Gtk::Stock::CANCEL)
dotwinebutton = Gtk::Button.new("~/.wine")
runbutton = Gtk::Button.new(Gtk::Stock::EXECUTE)

buttons = Gtk::HBox.new(false,5)
buttons.pack_start_defaults(cancelbutton)
buttons.pack_start_defaults(dotwinebutton)
buttons.pack_start_defaults(runbutton)

# packing together

vbox = Gtk::VBox.new(false,5)
vbox.pack_start_defaults(bottlelistlabel)
vbox.pack_start_defaults(bottlelist)
vbox.pack_start_defaults(newbottleexpander)
vbox.pack_start_defaults(buttons)

# Action

# Error window
def error_window (message)
		dialog = Gtk::MessageDialog.new(@window, 
										Gtk::Dialog::MODAL,
										Gtk::MessageDialog::ERROR,
										Gtk::MessageDialog::BUTTONS_OK,
								_("Error") )
		dialog.title = _("Error")
		dialog.secondary_text = message
		dialog.run
		dialog.destroy
end

# Create new bottle
def newbottle
	dialog = Gtk::FileChooserDialog.new(_("Choose or create an empty directory for the new bottle"),
                                        @window,
										Gtk::FileChooser::ACTION_CREATE_FOLDER,
										nil,
										[Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
										[Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
	dialog.current_folder = `echo $HOME/.local/share/bottles`.chomp
	while true
		if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
			system(@libdir + "/new.sh \"#{dialog.filename}\"")
			if $?.exitstatus == 8
				error_window(_("Chosen directory is not empty."))
			else
				bottle = "#{dialog.filename}"
				dialog.destroy
				return bottle
			end
		else
			dialog.destroy
			break
		end
	end
end

# Clone bottle
def clonebottle (chosenbottle)
	dialog = Gtk::FileChooserDialog.new(_("Choose or create an empty directory for the copy of the selected bottle"),
										@window,
										Gtk::FileChooser::ACTION_CREATE_FOLDER,
										nil,
										[Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
										[Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])
	dialog.current_folder = `echo $HOME/.local/share/bottles`.chomp
	while true
		if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
			system(@libdir + "/new.sh \"#{dialog.filename}\" \"#{chosenbottle}\"")
			if $?.exitstatus == 8
				error_window(_("Chosen directory is not empty."))
			elsif $?.exitstatus == 5
				error_window(_("Selected bottle is corrupted, have you been smashing files?"))
				dialog.destroy
				break
			else
				bottle = "#{dialog.filename}"
				dialog.destroy
				return bottle
			end
		else
			dialog.destroy
			break
		end
	end
end

# Buttons
cancelbutton.signal_connect("clicked")	{
	Gtk.main_quit
	exitus = 66
}
dotwinebutton.signal_connect("clicked")	{
	Gtk.main_quit
	exitus = 44
}
runbutton.signal_connect("clicked")	{
	if newbottletoggle.active?
		if clonebottletoggle.active?
			returning = clonebottle(bottlelist.active_text)
		else
			returning = newbottle
		end
	else
		returning = bottlelist.active_text
		if returning == `echo $HOME/.local/share/bottles/default`.chomp
			dialog = Gtk::MessageDialog.new(@window, 
											Gtk::Dialog::MODAL,
											Gtk::MessageDialog::WARNING,
											Gtk::MessageDialog::BUTTONS_YES_NO,
											_("You want to run software in default bottle"))
			dialog.secondary_text = _("If you install an application to default bottle, it'll be copied to each new bottle. Do you know, what you are doing?")
			dialog.run do |response|
				if response == Gtk::Dialog::RESPONSE_NO
					returning = nil
				end
				dialog.destroy
			end
		end
	end
	if returning != nil
		puts returning
		Gtk.main_quit
		exitus = 0
	end
}

# Set help text
help = Gtk::Tooltips.new
help.set_tip(bottlelist,_("Choose a Wine bottle, where the selected Windows application should be run"), nil)
help.set_tip(newbottleexpander,_("Show or hide extra options for running the selected Windows application in a new bottle"), nil)
help.set_tip(newbottletoggle,_("Whether to run the selected Windows application in a new bottle"), nil)
help.set_tip(clonebottletoggle,_("Whether to copy an existing bottle into the new one, the selected bottle from above combo box will be used as a \"parent\""), nil)
help.set_tip(cancelbutton,_("Do not run the selected Windows application at all"), nil)
help.set_tip(dotwinebutton,_("Do not use wibom, run the Windows  application in the standard ~/.wine folder"), nil)
help.set_tip(runbutton,_("Run the Windows application in the selected or in a new bottle"), nil)

# The window stuff

# Make pixbuf from icon name and size
def makepixbuf (icon, size)
	icon_theme = Gtk::IconTheme.default
	begin
	  img = icon_theme.load_icon(icon, size, Gtk::IconTheme::LOOKUP_USE_BUILTIN)
	rescue RuntimeError => e
	  puts e.message
	end
	return img
end

# Setting icon for all windows
icon_list = [makepixbuf("wibom-gtk", 128), makepixbuf("wibom-gtk", 64), makepixbuf("wibom-gtk", 48), makepixbuf("wibom-gtk", 32), makepixbuf("wibom-gtk", 24), makepixbuf("wibom-gtk", 16)]
Gtk::Window.set_default_icon_list(icon_list)

#main window initialization
@window = Gtk::Window.new

# Closing the window
@window.signal_connect("destroy") {
	exitus = 66
	Gtk.main_quit
}

@window.add(vbox)
@window.border_width = 10

# set window title and show & start main window
@window.set_title _("Wibom bottle chooser")
@window.show_all

Gtk.main
exit exitus
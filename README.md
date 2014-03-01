# 4 Character Sheet

After being frustrated with every character sheet for tablets (at least for android) that I could find, I decided to make my own Version.

It's exclusively for 4th Edition D&D and requires you to upload an exported character from the DDI Character Builder. It will also gather what little information comes with the offline CB, but usability will be quite slim unless you edit the .dnd4e file manually before upload.

# Installation

Installation should be pretty standard for anyone who has experience setting up Ruby on Rails apps

First, install ruby 2.1.0 or higher, then clone this project, add your own database.yml and secret_token.rb file (ommited from this archive for security reasons), migrate the DB and start the erver.

# Known issues

Power Point tracking for Psion, Battlemind, Assassin and Ardent are not implemented.

Sometimes taking a long rest as a wizard can cause your powers to disappear. Just rest again and they should resurface.

If you find any other bugs, issues or have suggestions, open an issue or send an email to chars4e@googlemail.com

#!/usr/bin/env bash
# script to create packages of wibom
# Released under the terms of BSD licence
# http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5
# Copyright © 2010, Miro Hrončok [hroncok.cz]

USAGE="Usage: $0 version revision"

if [ -z "$2" ]; then
	echo $USAGE
	exit 1
fi

cd .. # working dir

## Temp dir
cp -r wibom/usr .
cd usr
find . -name '.svn' -exec trash {} \; 2>/dev/null
cd .. # working dir

# Tarball
tar -cj usr > wibom-gtk-${1}-${2}.tar.bz2
echo "tar-bzip: vytvářím balík „wibom-gtk“ v „wibom-gtk-${1}-${2}.tar.bz2“."

nano wibom.changes

echo "# RPM" > wibom.spec
echo "#" >> wibom.spec
echo "# spec file for package wibom (Version ${1})" >> wibom.spec
echo "#" >> wibom.spec
echo "# Copyright © 2009-2010, Miro Hrončok [hroncok.cz]" >> wibom.spec
echo "" >> wibom.spec
echo "" >> wibom.spec
echo "" >> wibom.spec
echo "Name:           wibom" >> wibom.spec
echo "License:        BSDL" >> wibom.spec
echo "Group:          System/Emulators/PC" >> wibom.spec
echo "Summary:        Wine Bottle Management" >> wibom.spec
echo "Version:        ${1}" >> wibom.spec
echo "Release:        ${2}" >> wibom.spec
echo "Source:         wibom-gtk-${1}-${2}.tar.bz2" >> wibom.spec
echo "BuildRoot:      %{_tmppath}/%{name}-%{version}-build" >> wibom.spec
echo "BuildArch:      noarch" >> wibom.spec
echo "# Manual requires to avoid hard require to bash-static" >> wibom.spec
echo "AutoReqProv:    off" >> wibom.spec
echo "# Keep the following dependencies in sync with obs-worker package" >> wibom.spec
echo "Requires:       bash" >> wibom.spec
echo "Requires:       wine" >> wibom.spec
echo "%if 0%{?suse_version}" >> wibom.spec
echo "BuildRequires:  update-desktop-files" >> wibom.spec
echo "Recommends:     wibom-gtk" >> wibom.spec
echo "Recommends:     trash-cli" >> wibom.spec
echo "Recommends:     wget" >> wibom.spec
echo "Recommends:     python-minimal" >> wibom.spec
echo "%endif" >> wibom.spec
echo "" >> wibom.spec
echo "%description" >> wibom.spec
echo "This package contains Wine Bottle Management." >> wibom.spec
echo "" >> wibom.spec
echo "%package gtk" >> wibom.spec
echo "Requires:       ruby" >> wibom.spec
echo "Requires:       trash-cli" >> wibom.spec
echo "BuildArch:      noarch" >> wibom.spec
echo "Requires:       ruby-gnome2" >> wibom.spec
echo "Requires:       rubygem-gettext" >> wibom.spec
echo "Requires:       hicolor-icon-theme" >> wibom.spec
echo "Group:          System/Emulators/PC" >> wibom.spec
echo "%if 0%{?suse_version}" >> wibom.spec
echo "BuildRequires:  update-desktop-files" >> wibom.spec
echo "Recommends:     zenity" >> wibom.spec
echo "%endif" >> wibom.spec
echo "Summary:        GTK interface to Wine Bottle Management" >> wibom.spec
echo "" >> wibom.spec
echo "%description gtk" >> wibom.spec
echo "This package contains GTK interface for Wine Bottle Management." >> wibom.spec
echo "" >> wibom.spec
echo "%package bottle-chooser" >> wibom.spec
echo "Requires:       bash" >> wibom.spec
echo "Requires:       wibom" >> wibom.spec
echo "Requires:       ruby" >> wibom.spec
echo "Requires:       ruby-gnome2" >> wibom.spec
echo "Requires:       rubygem-gettext" >> wibom.spec
echo "Requires:       hicolor-icon-theme" >> wibom.spec
echo "BuildArch:      noarch" >> wibom.spec
echo "Group:          System/Emulators/PC" >> wibom.spec
echo "%if 0%{?suse_version}" >> wibom.spec
echo "BuildRequires:  update-desktop-files" >> wibom.spec
echo "Recommends:     wibom-gtk" >> wibom.spec
echo "%endif" >> wibom.spec
echo "Summary:        Halfautomatic bottle chooser for Wine Bottle Management" >> wibom.spec
echo "" >> wibom.spec
echo "%description bottle-chooser" >> wibom.spec
echo "This package contains automatic bottle chooser for Wine Bottle Management." >> wibom.spec
echo "" >> wibom.spec
echo "%prep" >> wibom.spec
echo "%setup -c \${name}-%{version}-%{release}" >> wibom.spec
echo "" >> wibom.spec
echo "%build" >> wibom.spec
echo "echo \"Nothing to do...\"" >> wibom.spec
echo "" >> wibom.spec
echo "%install" >> wibom.spec
echo "[ -d %{buildroot} ] || mkdir -p %{buildroot}" >> wibom.spec
echo "cp -r * %{buildroot}" >> wibom.spec
echo "%if 0%{?suse_version}" >> wibom.spec
echo "%suse_update_desktop_file -r -G \"Wine bottle management\" %{buildroot}/usr/share/applications/wibom-gtk.desktop Office Database" >> wibom.spec
echo "%endif" >> wibom.spec
echo "" >> wibom.spec
echo "%clean" >> wibom.spec
echo "rm -rf %{buildroot}" >> wibom.spec
echo "" >> wibom.spec
echo "%files" >> wibom.spec
echo "%defattr(-,root,root)" >> wibom.spec
echo "/usr/bin/wibom" >> wibom.spec
echo "%dir /usr/lib/wibom/" >> wibom.spec
echo "/usr/lib/wibom/*.sh" >> wibom.spec
echo "/usr/share/man/man1/*" >> wibom.spec
echo "/usr/share/man/cs" >> wibom.spec
echo "" >> wibom.spec
echo "%files gtk" >> wibom.spec
echo "%defattr(-,root,root)" >> wibom.spec
echo "/usr/bin/wibom-gtk" >> wibom.spec
echo "/usr/share/icons/hicolor" >> wibom.spec
echo "/usr/share/applications/wibom-gtk.desktop" >> wibom.spec
echo "/usr/share/locale/cs/LC_MESSAGES/wibom-gtk.mo" >> wibom.spec
echo "" >> wibom.spec
echo "%files bottle-chooser" >> wibom.spec
echo "%defattr(-,root,root)" >> wibom.spec
echo "/usr/bin/wibom-bottle-chooser" >> wibom.spec
echo "%dir /usr/lib/wibom/" >> wibom.spec
echo "/usr/lib/wibom/bottlechooser.rb" >> wibom.spec
echo "/usr/share/applications/wibom-bottle-chooser.desktop" >> wibom.spec
echo "" >> wibom.spec
echo "%changelog" >> wibom.spec

echo "rpm-spec: vytvářím soubor „wibom.spec“ v „wibom.spec“."

## Debian packages
#  bottle chooser package
rm -r wibom-bottle-chooser-package/usr/
mkdir -p wibom-bottle-chooser-package/usr/bin
mkdir -p wibom-bottle-chooser-package/usr/lib/wibom
mkdir -p wibom-bottle-chooser-package/usr/share/applications
mv usr/bin/wibom-bottle-chooser wibom-bottle-chooser-package/usr/bin/wibom-bottle-chooser
mv usr/lib/wibom/bottlechooser.rb wibom-bottle-chooser-package/usr/lib/wibom/bottlechooser.rb
mv usr/share/applications/wibom-bottle-chooser.desktop wibom-bottle-chooser-package/usr/share/applications/wibom-bottle-chooser.desktop

cd wibom-bottle-chooser-package/DEBIAN

echo "Package: wibom-bottle-chooser" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wine, bash, wibom (=${1}-${2})" >> control
echo "Suggests: wibom-gtk" >> control
echo "Installed-Size: `du --apparent-size -s ../usr/ | head -c2`" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: Halfautomatic bottle chooser for wibom." >> control

cd ../.. # working dir
dpkg -b wibom-bottle-chooser-package/ wibom-bottle-chooser_${1}-${2}_all.deb
rm debian/debs/*.deb
mv wibom-bottle-chooser_${1}-${2}_all.deb debian/debs

#  wibom package
rm -r wibom-package/usr/
mkdir wibom-package/usr
mv usr/lib wibom-package/usr/lib
mkdir wibom-package/usr/bin
mkdir wibom-package/usr/share
mv usr/bin/wibom wibom-package/usr/bin/wibom
mv usr/share/man wibom-package/usr/share/man

cd wibom-package/DEBIAN

echo "Package: wibom" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wine, bash" >> control
echo "Recommends: xdg-utils, trash-cli, wget, python-minimal" >> control
echo "Suggests: wibom-gtk, wibom-bottle-chooser" >> control
echo "Installed-Size: `du --apparent-size -s ../usr/ | head -c2`" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: Wine bottle management is used to manage so-called Wine bottles. http://wibom.sourceforge.net/" >> control

cd ../.. # working dir
dpkg -b wibom-package/ wibom_${1}-${2}_all.deb
mv wibom_${1}-${2}_all.deb debian/debs

#  wibom-additional-icons package
rm -r wibom-additional-icons-package/usr/
mkdir -p wibom-additional-icons-package/usr/share/icons/hicolor/scalable/apps
mkdir -p wibom-additional-icons-package/usr/share/icons/hicolor/16x16/apps
mkdir -p wibom-additional-icons-package/usr/share/icons/hicolor/24x24/apps

mv usr/share/icons/hicolor/scalable/apps/wine-* wibom-additional-icons-package/usr/share/icons/hicolor/scalable/apps
mv usr/share/icons/hicolor/16x16/apps/wine-* wibom-additional-icons-package/usr/share/icons/hicolor/16x16/apps
mv usr/share/icons/hicolor/24x24/apps/wine-* wibom-additional-icons-package/usr/share/icons/hicolor/24x24/apps

cd wibom-additional-icons-package/DEBIAN

echo "Package: wibom-additional-icons" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wibom-gtk (=${1}-${2}), hicolor-icon-theme" >> control
echo "Installed-Size: `du --apparent-size -s ../usr/ | head -c3`" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: Missing icons for wibom-gtk." >> control

cd ../.. # working dir
dpkg -b wibom-additional-icons-package/ wibom-additional-icons_${1}-${2}_all.deb
mv wibom-additional-icons_${1}-${2}_all.deb debian/debs

#  wibom-gtk package
rm -r wibom-gtk-package/usr/
mv usr wibom-gtk-package/usr

cd wibom-gtk-package/DEBIAN

echo "Package: wibom-gtk" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wibom (=${1}-${2}), ruby, libgettext-ruby1.8, libgtk2-ruby1.8, sysvinit-utils, coreutils, debianutils, hicolor-icon-theme, trash-cli" >> control
echo "Recommends: zenity, winetricks" >> control
echo "Installed-Size: `du --apparent-size -s ../usr/ | head -c3`" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: GTK frontend for wibom." >> control

cd ../.. # working dir
dpkg -b wibom-gtk-package/ wibom-gtk_${1}-${2}_all.deb
mv wibom-gtk_${1}-${2}_all.deb debian/debs

cd wibom-metapackages/DEBIAN

echo "Package: wibom-debian" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wibom (=${1}-${2}), wibom-gtk (=${1}-${2}), wibom-bottle-chooser (=${1}-${2}), wibom-additional-icons (=${1}-${2})" >> control
echo "Installed-Size: 0" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: Debian metapackage for wibom." >> control

cd ../.. # working dir
dpkg -b wibom-metapackages/ wibom-debian_${1}-${2}_all.deb
mv wibom-debian_${1}-${2}_all.deb debian/debs

cd wibom-metapackages/DEBIAN

echo "Package: wibom-ubuntu" > control
echo "Version: ${1}-${2}" >> control
echo "Section: otherosfs" >> control
echo "Priority: optional" >> control
echo "Architecture: all" >> control
echo "Depends: wibom (=${1}-${2}), wibom-gtk (=${1}-${2}), wibom-bottle-chooser (=${1}-${2})" >> control
echo "Installed-Size: 0" >> control
echo "Maintainer: Miroslav Hrončok [miro@hroncok.cz]" >> control
echo "Description: Ubuntu metapackage for wibom." >> control

cd ../.. # working dir
dpkg -b wibom-metapackages/ wibom-ubuntu_${1}-${2}_all.deb
mv wibom-ubuntu_${1}-${2}_all.deb debian/debs

cd debian
dpkg-scanpackages debs /dev/null | gzip > ./Packages.gz
cd .. # working dir
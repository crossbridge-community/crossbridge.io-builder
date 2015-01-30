#!/bin/bash

CBCHECKOUT="crossbridge"
GHPAGES="gh-pages"
BUILDDIR="build"
APIDOCS="source/docs/apidocs"

# Echoes the command and executes it.
@() {
	echo "$*"
	"$@"
}

if [[ ! -d "$CBCHECKOUT" ]]; then
	echo "You must have a checkout of crossbridge named '$CBCHECKOUT' in this directory."
	exit 1
fi

if [[ ! -d "$GHPAGES" ]]; then
	echo "You must have a checkout of the gh-pages branch of crossbridge, named '$GHPAGES'"
	echo "This would be enough: "
	echo " > git clone -b gh-pages --depth 1 git@github.com:crossbridge-community/crossbridge.git gh-pages"
	exit 1
fi

if [[ ! -d "$APIDOCS" ]]; then
	echo "You will need to have a copy of a generated apidocs folder."
	echo "Put it in '$APIDOCS'."
	echo "Please use the latest crossbridge stable release."
	exit 1
fi

echo "Updating site from local crossbridge checkout."
@ bundle exec ruby update_site_from_repo.rb

echo "Generating site..."
@ bundle exec middleman build

echo "Committing to gh-pages branch"
@ rsync --exclude=".git" --recursive --delete "$BUILDDIR"/ "$GHPAGES"/

pushd "$GHPAGES"
@ git add .
@ git commit -m "Github pages auto-deploy."
@ git push
popd

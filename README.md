These are the overlay files for Tribblix

Each overlay has two files:

The pkgs file lists the packages contained in the overlay

The ovl file describes the overlay, its name, other overlays it depends
on, and a version which should be updated if the list of packages
changes, or any of the other overlay attributes change

The valid keywords in the ovl files are:

VERSION=

Required. Increment if the list of packages or overlay dependencies
changes.

NAME=

Required. The pretty name that can be presented to users.

REQUIRES=

Optional. Specify an overlay this overlay depends on; repeat the
keyword multiple times for multiple dependencies.

SERVICE=

Optional. An SMF service associated with this overlay; repeat the
keyword multiple times for multiple services. Used by the zap
list-services/show-services/enable-services/disable-services subcommands
to manage the services associated with an overlay.

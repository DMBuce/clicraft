#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])
AC_INIT([clicraft], [0.0.3], [https://github.com/DMBuce/clicraft/issues], [clicraft], [https://github.com/DMBuce/clicraft])

dnl package info
AC_SUBST([PACKAGE], [$PACKAGE_NAME])
AC_SUBST([PROG], [$PACKAGE_TARNAME])
AC_SUBST([VERSION], [$PACKAGE_VERSION])
AC_SUBST([BUGREPORT], [$PACKAGE_BUGREPORT])
AC_SUBST([URL], [$PACKAGE_URL])

dnl important dirs
AC_SUBST([CONFDIR], [$sysconfdir/$PROG])
AC_SUBST([EXECDIR], [$libexecdir/$PROG])
AC_SUBST([SERVER_DIR], [$localstatedir/lib/$PROG])

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_LN_S

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([
Makefile
src/Makefile
src/bin/clicraft
src/lib/defaults.sh
src/etc/clicraft-defaults.conf
scripts/bash_completion
])
AC_OUTPUT

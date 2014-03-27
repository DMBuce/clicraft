#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.59])
AC_INIT([clicraft], [0.0.11], [https://github.com/DMBuce/clicraft/issues], [clicraft])

dnl package info
AC_SUBST([PACKAGE],   [$PACKAGE_NAME])
AC_SUBST([PROG],      [$PACKAGE_TARNAME])
AC_SUBST([VERSION],   [$PACKAGE_VERSION])
AC_SUBST([BUGREPORT], [$PACKAGE_BUGREPORT])
AC_SUBST([URL],       [http://dmbuce.github.com/clicraft/])

AC_SUBST([BINDIR],    [$bindir])

dnl --enable-shortdirs
AC_ARG_ENABLE([shortdirs],
	AS_HELP_STRING([--enable-shortdirs], [Use short paths for installation directories]))

AS_IF([test "x$enable_shortdirs" = "xyes"],
      AC_SUBST([CONFDIR], [$sysconfdir]),
      AC_SUBST([CONFDIR], [$sysconfdir/$PROG])
)

AS_IF([test "x$enable_shortdirs" = "xyes"],
      AC_SUBST([EXECDIR], [$libexecdir]),
      AC_SUBST([EXECDIR], [$libexecdir/$PROG])
)

AS_IF([test "x$enable_shortdirs" = "xyes"],
      AC_SUBST([DEFAULT_SERVER_DIR], [$localstatedir]),
      AC_SUBST([DEFAULT_SERVER_DIR], [$localstatedir/lib/$PROG])
)

# Checks for programs.
AC_PROG_INSTALL

AC_CONFIG_FILES([
Makefile
src/bin/clicraft
src/lib/defaults.sh
src/etc/clicraft-defaults.conf
src/etc/clicraft-starmade.conf
scripts/bash_completion
scripts/cron
scripts/logrotate
])
AC_OUTPUT

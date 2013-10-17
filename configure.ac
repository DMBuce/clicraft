#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.59])
AC_INIT([clicraft], [0.0.7], [https://github.com/DMBuce/clicraft/issues], [clicraft])

dnl package info
AC_SUBST([PACKAGE],   [$PACKAGE_NAME])
AC_SUBST([PROG],      [$PACKAGE_TARNAME])
AC_SUBST([VERSION],   [$PACKAGE_VERSION])
AC_SUBST([BUGREPORT], [$PACKAGE_BUGREPORT])
AC_SUBST([URL],       [http://dmbuce.github.com/clicraft/])

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

dnl --with-mcexplore
AC_ARG_WITH([mcexplore],
	AS_HELP_STRING([--with-mcexplore], [Include mcexplore helper script]))

AS_IF([test "x$with_mcexplore" = "xyes"],
      AC_SUBST([WITH_MCEXPLORE], [yes]),
      AC_SUBST([WITH_MCEXPLORE], [no])
)

dnl --with-c10t
AC_ARG_WITH([c10t],
	AS_HELP_STRING([--with-c10t], [Include c10t helper script]))

AS_IF([test "x$with_c10t" = "xyes"],
      AC_SUBST([WITH_C10T], [yes]),
      AC_SUBST([WITH_C10T], [no])
)

dnl --with-mmat
AC_ARG_WITH([mmat],
	AS_HELP_STRING([--with-mmat], [Include mmat helper script]))

AS_IF([test "x$with_mmat" = "xyes"],
      AC_SUBST([WITH_MMAT], [yes]),
      AC_SUBST([WITH_MMAT], [no])
)

# Checks for programs.
AC_PROG_INSTALL

AC_CONFIG_FILES([
Makefile
src/bin/clicraft
src/lib/defaults.sh
src/etc/clicraft-defaults.conf
scripts/bash_completion
scripts/cron
scripts/logrotate
])
AC_OUTPUT

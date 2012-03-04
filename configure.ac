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
scripts/Makefile
scripts/bash_completion
])
AC_OUTPUT

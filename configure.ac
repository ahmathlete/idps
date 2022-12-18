AC_INIT([idps],[0.0.0.9])
#https://unconj.ca/blog/an-autoconf-primer-for-r-package-authors.html
# Find the compiler and compiler flags used by R.
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`

# Search for a system library, in this case the fftw3 library.
AC_CHECK_HEADERS(fftw3.h, [], [AC_ERROR([The fftw3 library headers are required.])])

have_fftw3=no
FFTW3_FFLAGS=""
FFTW3_LIBS="-lfftw3"

PKG_PROG_PKG_CONFIG

if test [ -n "$PKG_CONFIG" ] ; then
  AC_MSG_CHECKING([pkg-config for fftw3])
  if $PKG_CONFIG --exists fftw3; then
    have_fftw3=yes
    FFTW3_FFLAGS=`"${PKG_CONFIG}" --cflags fftw3`
    FFTW3_LIBS=`"${PKG_CONFIG}" --libs fftw3`
  fi
  AC_MSG_RESULT([${have_fftw3}])
fi

if test "x${have_fftw3}" = xno; then
  AC_CHECK_HEADERS(fftw3.h, [have_fftw3=yes], [AC_ERROR(
    [The fftw3 library headers are required.]
  )])
fi
AC_SUBST([PKG_LIBS],    ["${LIBS} ${PKG_LIBS}"])

# Write the flags into the src/Makevars file.
AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS}"])
AC_SUBST([PKG_LIBS], ["${LIBS} ${PKG_LIBS}"])
AC_SUBST(FFTW3_FFLAGS)
AC_SUBST(FFTW3_LIBS)
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

echo "
  --------------------------------------------------
  Configuration for ${PACKAGE_NAME} ${PACKAGE_VERSION}
    cflags: ${PKG_CPPFLAGS}
    libs:   ${PKG_LIBS}
    FFTW3_FFLAGS: ${FFTW3_FFLAGS}
    FFTW3_LIBS:   ${FFTW3_LIBS}
  --------------------------------------------------
"

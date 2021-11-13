#!/bin/bash
set -ev

# !!!NOTE!!! This script is intended to be run as the sage user NOT root.
SAGE_SRC_TARGET=${1%/}
BRANCH=$2

if [ -z $SAGE_SRC_TARGET ]; then
  >&2 echo "Must specify a target directory for the sage source checkout"
  exit 1
fi

if [ -z $BRANCH ]; then
  >&2 echo "Must specify a branch to build"
  exit 1
fi

N_CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

export SAGE_FAT_BINARY="no"
# Just to be sure Sage doesn't try to build its own GCC (even though
# it shouldn't with a recent GCC package from the system and with gfortran)
export SAGE_INSTALL_GCC="no"
export MAKE="make -j${N_CORES}"
cd "$SAGE_SRC_TARGET"
git clone --depth 1 --branch ${BRANCH} https://github.com/sagemath/sage.git
cd sage

sed -i -e 's|sdh_configure --with-external-blas --with-external-lapack --with-external-glpk|sdh_configure --with-external-glpk|' ./build/pkgs/igraph/spkg-install.in

make configure
./configure                                     \
    --with-system-boost_cropped=force           \
    --with-system-bzip2=force                   \
    --with-system-curl=force                    \
    --with-system-freetype=force                \
    --with-system-gc=force                      \
    --with-system-gfortran=force                \
    --with-system-git=force                     \
    --with-system-gmp=force                     \
    --with-system-graphviz=force                \
    --with-system-iconv=force                   \
    --with-system-libatomic_ops=force           \
    --with-system-libgd=force                   \
    --with-system-libpng=force                  \
    --with-system-libxml2=force                 \
    --with-system-ncurses=force                 \
    --with-system-openssl=force                 \
    --with-system-pandoc=force                  \
    --with-system-patch=force                   \
    --with-system-pcre=force                    \
    --with-system-pkgconf=force                 \
    --with-system-python3=force                 \
    --with-system-readline=force                \
    --with-system-sqlite=force                  \
    --with-system-xz=force                      \
    --with-system-yasm=force                    \
    --with-system-zeromq=force                  \
    --with-system-zlib=force                    \
    --enable-4ti2                               \
    --enable-barvinok                           \
    --enable-benzene                            \
    --enable-bliss                              \
    --enable-buckygen                           \
    --enable-cbc                                \
    --enable-coxeter3                           \
    --enable-cryptominisat                      \
    --enable-csdp                               \
    --enable-cunningham_tables                  \
    --enable-d3js                               \
    --enable-dot2tex                            \
    --enable-e_antic                            \
    --enable-fricas                             \
    --enable-frobby                             \
    --enable-gap_jupyter                        \
    --enable-gap_packages                       \
    --enable-glucose                            \
    --enable-gp2c                               \
    --enable-graphviz                           \
    --enable-igraph                             \
    --enable-ipympl                             \
    --enable-isl                                \
    --enable-jupyterlab_widgets                 \
    --enable-jupyter_packaging                  \
    --enable-kenzo                              \
    --enable-latte_int                          \
    --enable-libnauty                           \
    --enable-libogg                             \
    --enable-libsemigroups                      \
    --enable-libxml2                            \
    --enable-lidia                              \
    --enable-lrslib                             \
    --enable-mcqd                               \
    --enable-meataxe                            \
    --enable-mpfrcx                             \
    --enable-ninja_build                        \
    --enable-nodejs                             \
    --enable-normaliz                           \
    --enable-notedown                           \
    --enable-pandoc                             \
    --enable-pandoc_attributes                  \
    --enable-pari_elldata                       \
    --enable-pari_galpol                        \
    --enable-pari_nftables                      \
    --enable-pari_seadata                       \
    --enable-plantri                            \
    --enable-polylib                            \
    --enable-primecount                         \
    --enable-pycosat                            \
    --enable-pynormaliz                         \
    --enable-pysingular                         \
    --enable-python_igraph                      \
    --enable-qhull                              \
    --enable-r_jupyter                          \
    --enable-rst2ipynb                          \
    --enable-rubiks                             \
    --enable-saclib                             \
    --enable-sage_numerical_backends_coin       \
    --enable-sage_sws2rst                       \
    --enable-singular_jupyter                   \
    --enable-sip                                \
    --enable-sirocco                            \
    --enable-speaklater                         \
    --enable-symengine                          \
    --enable-symengine_py                       \
    --enable-tdlib                              \
    --enable-texttable                          \
    --enable-tides                              \
    --enable-topcom
#   --with-system-cmake=force                   \
#   --enable-database_cremona_ellcurve          \
#   --enable-database_jones_numfield            \
#   --enable-database_kohel                     \
#   --enable-database_mutation_class            \
#   --enable-database_odlyzko_zeta              \
#   --enable-database_stein_watkins_mini        \
#   --enable-database_symbolic_data             \
#   --enable-jupymake                           \
#   --enable-p_group_cohomology                 \
#   --enable-polytopes_db_4d                    \
#   --enable-scipoptsuite                       \
#   --enable-texlive                            \

make

./sage -i admcycles
./sage -i beautifulsoup4
./sage -i biopython
./sage -i jupyterlab
./sage -i nibabel
./sage -i nodeenv
./sage -i ore_algebra
./sage -i pybtex
./sage -i pyflakes
# ./sage -i pygraphviz
./sage -i pyopenssl
./sage -i pytest
./sage -i pyx
./sage -i sage_flatsurf
./sage -i slabbe
./sage -i snappy
./sage -i sqlalchemy
./sage -i surface_dynamics
./sage -i tox

make

# Clean up artifacts from the sage build that we don't need for runtime or
# running the tests
#
# Unfortunately none of the existing make targets for sage cover this ground
# exactly

cd "$SAGE_SRC_TARGET"/sage/
make misc-clean

rm -rf upstream/
rm -rf src/doc/output/doctrees/

# Strip binaries -- this saves gigabytes of space and takes a while...
LC_ALL=C find local/lib local/bin -type f -exec strip '{}' ';' 2>&1 | grep -v "File format not recognized" |  grep -v "File truncated" || true

from setuptools import Extension, setup
from Cython.Build import cythonize
import numpy as np
import os

os.environ["CC"] = "g++ -stdlib=libc++"

extensions = [
    Extension("btrack", ["beat_tracker.pyx"],
              language="c++",
              include_dirs=["BTrack/src", np.get_include()],
              libraries=["fftw3", "fftw3f", "samplerate"],
              library_dirs=["/usr/local/lib"],
              extra_compile_args=["-DUSE_FFTW"]
              )  # ,
    # Extension("*", [],
    #           language="c++",
    #           include_dirs=["BTrack/src"],
    #           libraries=["fftw3", "fftw3f", "samplerate", ],
    #           library_dirs=["/usr/local/lib"],
    #           extra_compile_args=["-stdlib=libc++", "-DUSE_FFTW"]
    #           )
]

setup(
    name='BTrack Python Wrapper',
    ext_modules=cythonize(extensions, annotate=True, compiler_directives={"language_level": 3}),
    zip_safe=False,
)
